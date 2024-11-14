FROM python:slim

RUN pip install fastapi uvicorn

WORKDIR /app

COPY dummy-api/main.py /app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]