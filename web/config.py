import os

app_dir = os.path.abspath(os.path.dirname(__file__))


class BaseConfig:
    DEBUG = True
    POSTGRES_URL = "postgres-server-es81dec2023.postgres.database.azure.com"
    POSTGRES_USER = "postgresadmin@postgres-server-es81dec2023"
    POSTGRES_PW = "P@ssw0rd1234"
    POSTGRES_DB = "techconfdb"
    DB_URL = f'postgresql://{POSTGRES_USER}:{POSTGRES_PW}@{POSTGRES_URL}/{POSTGRES_DB}'
    SQLALCHEMY_DATABASE_URI = os.getenv('SQLALCHEMY_DATABASE_URI') or DB_URL
    CONFERENCE_ID = 1
    SECRET_KEY = 'LWd2tzlprdGHCIPHTd4tp5SBFgDszm'
    SERVICE_BUS_CONNECTION_STRING = 'Endpoint=sb://servicebus-es81dec2023.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=QvARKfRRV2tF318pu4eS7bwKxN9L1NOAi+ASbOJpay4='
    SERVICE_BUS_QUEUE_NAME = 'notificationqueue'
    ADMIN_EMAIL_ADDRESS = 'info@techconf.com'
    # Configuration not required, required SendGrid Account
    SENDGRID_API_KEY = os.getenv('SENDGRID_API_KEY')


class DevelopmentConfig(BaseConfig):
    DEBUG = True


class ProductionConfig(BaseConfig):
    DEBUG = False
