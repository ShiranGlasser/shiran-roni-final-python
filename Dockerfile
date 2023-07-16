# start by pulling the python image
FROM python:3.7-alpine

# switch working directory
WORKDIR /app

# copy every content related to Flask application to the image
COPY . .

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt

EXPOSE 5000

# configure the container to run in an executed manner
ENTRYPOINT [ "python" ]

CMD [ "app.py" ]
