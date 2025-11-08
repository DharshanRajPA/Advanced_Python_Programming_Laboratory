FROM public.ecr.aws/lambda/python:3.11

WORKDIR /var/task

# Install system tools
RUN yum install -y gcc make rust cargo && \
    python3.11 -m pip install --upgrade pip setuptools wheel

# Copy requirements and install them directly
COPY requirements.txt .
RUN python3.11 -m pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Lambda entrypoint
CMD ["ECommerce_API.lambda_handler"]