# Use the official Python 3.12 slim image as a base
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Copy your local requirements.txt file to the container
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy your training script into the container
COPY ./src ./src
COPY ./Data ./Data

# Command to execute when the container starts
CMD ["python", "./src/train.py"]
