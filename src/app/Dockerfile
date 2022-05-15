FROM python:3.9.11-alpine3.14

RUN adduser --system worker
USER worker
WORKDIR /home/worker

COPY --chown=worker:users demo-jres/app/main.py .
COPY --chown=worker:users requirements.txt .
ENV PATH="/home/worker/.local/bin:${PATH}"
RUN pip install --user -r requirements.txt

EXPOSE 9090

CMD [ "python3", "main.py" ]
