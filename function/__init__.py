import logging
import azure.functions as func
import psycopg2
import os
from datetime import datetime
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail


def main(msg: func.ServiceBusMessage):
    """Process the message which is the notification_id
    - Query the database using psycopg2 library for the given notification to retrieve the subject and message
    - Query the database to retrieve a list of attendees (email and first name)
    - Loop through each attendee and send a personalized subject message
    - After the notification, update the notification status with the total number of attendees notified

    Args:
        msg (func.ServiceBusMessage): _description_
    """
    notification_id = int(msg.get_body().decode('utf-8'))
    logging.info('Python ServiceBus queue trigger processed message: %s', notification_id)

    # Get connection to database
    dbname = 'techconfdb'
    user = 'postgresadmin@postgres-server-es81'
    host = 'postgres-server-es81.postgres.database.azure.com'
    password = 'P@ssw0rd1234'
    port = '5432'
    sslmode = 'true'

    conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host, port=port, sslmode=sslmode)

    try:
        cur = conn.cursor()
        cur.execute(f"SELECT message, subject FROM notification WHERE id = {notification_id};")
        # Get notification message and subject from database using the notification_id
        record = cur.fetchone()
        message = record[0]
        subject = record[1]

        # Get attendees email and name
        attendee = cur.execute("SELECT first_name, last_name, email FROM attendee;")
        first_name = attendee[0]
        last_name = attendee[1]

        # Loop through each attendee and send an email with a personalized subject
        for attendee in cur.fetchall():
            subject += " for " + first_name + " " + last_name

            email = Mail(from_email='eduard.schildner@gmail.com',
                         to_emails=attendee[2],
                         subject=subject,
                         html_content=message)
            sg = SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
            response = sg.send(email)

            logging.info(response.status_code)
            logging.info(response.body)
            logging.info(response.headers)

        # Update the notification table by setting the completed_date
        # and updating the status with the total number of attendees notified.
        completed_date = datetime.utcnow()
        cur.execute(f"UPDATE notification SET completed_date = '{completed_date}' WHERE id = {notification_id};")
        attendees = cur.rowcount
        cur.execute(f"UPDATE notification SET status = 'Notified {attendees} attendees' WHERE id = {notification_id};")

    except (Exception, psycopg2.DatabaseError) as error:
        logging.error(error)
    finally:
        # Close connection
        conn.close()
