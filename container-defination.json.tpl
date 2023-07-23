[
  {
    "name": "my-container",
    "image": "wordpress:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "memory": 512,
    "cpu": 256
  }
]
  