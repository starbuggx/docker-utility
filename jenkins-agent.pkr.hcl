packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = "~> 1"
    }
  }
}

# Define Docker builder with Dockerfile
source "docker" "jenkins-agent" {
  commit = true
  build {
    path = "Dockerfile.jenkins-agent"
  }
}

# Build the Docker image
build {
  sources = ["source.docker.jenkins-agent"]
  post-processors {
    # Tag the Docker image for Docker Hub
    post-processor "docker-tag" {
      repository = "starbuggx/jenkins-agent-utility"
      # tags       = ["latest"]
      tags = [var.git_branch == "main" ? "latest" : var.git_branch]
    }
  }
}

# Variable for git branch
variable "git_branch" {
  type    = string
  default = "latest"
}

# packer init
# packer build jenkins-agent.pkr.hcl
# packer build -var git_branch=$(git rev-parse --abbrev-ref HEAD) jenkins-agent.pkr.hcl
# get credentials from .docker/config.json
