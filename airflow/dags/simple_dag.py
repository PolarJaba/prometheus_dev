import psycopg2
import json
from airflow import settings
from psycopg2.extras import execute_values
from psycopg2.extensions import register_adapter, AsIs
from airflow import settings
from sqlalchemy import create_engine
from airflow import DAG
from selenium.common.exceptions import NoSuchElementException
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.bash_operator import BashOperator
from airflow.utils.log.logging_mixin import LoggingMixin
import logging
from logging import handlers
from airflow import models
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.hooks.base_hook import BaseHook
from airflow.models import Variable
import time
from datetime import datetime, timedelta
import os



# Connections settings
# Загружаем данные подключений из JSON файла
with open('/opt/airflow/dags/config_connections.json', 'r') as conn_file:
    connections_config = json.load(conn_file)

# Получаем данные конфигурации подключения и создаем конфиг для клиента
conn_config = connections_config['psql_connect']

config = {
    'database': conn_config['database'],
    'user': conn_config['user'],
    'password': conn_config['password'],
    'host': conn_config['host'],
    'port': conn_config['port'],
}

conn = psycopg2.connect(**config)

logging_level = os.environ.get('LOGGING_LEVEL', 'DEBUG').upper()
logging.basicConfig(level=logging_level)
log = logging.getLogger(__name__)
log_handler = handlers.RotatingFileHandler('/opt/airflow/logs/airflow.log',
                                           maxBytes=5000,
                                           backupCount=5)

log_handler.setLevel(logging.DEBUG)
log_formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
log_handler.setFormatter(log_formatter)
log.addHandler(log_handler)

# Параметры по умолчанию
default_args = {
    "owner": "admin_1T",
    # 'start_date': days_ago(1),
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(dag_id='simple_dag',
                tags=['admin_1T'],
                start_date=datetime(2023, 11, 4),
                schedule_interval='*/5 * * * *',
                default_args=default_args
                )

class DatabaseManager:
    def __init__(self, conn):
        self.conn = conn
        self.cur = conn.cursor()
        self.log = LoggingMixin().log

    def create_table(self):
        drop_table_query = "DROP TABLE IF EXISTS prov;"
        self.cur.execute(drop_table_query)
        self.log.info('Удалена таблица')
        create_table_query = """
        CREATE TABLE IF NOT EXISTS prov(
            vacancy_id VARCHAR(255) NOT NULL,
            vacancy_name VARCHAR(100));"""
        
        self.cur.execute(create_table_query)
        self.conn.commit()
        self.log.info('Таблица создана в базе данных.')

    def print_hello(self):
        return 'Hello world from first Airflow DAG!'

    def alert_checking(self):
        try:
            return (20/0)
        except Exception as e:
            self.log.error(f'Error {e}')

def run_all(**context):
    log = context['ti'].log
    log.info('Запуск')
    func = DatabaseManager(conn)
    func.print_hello()
    func.create_table()
    func.alert_checking

hello_operator = PythonOperator(task_id='hello_task', python_callable=run_all, dag=dag)

hello_operator