FROM mcr.microsoft.com/powershell

RUN apt update -y
RUN apt upgrade -y
RUN apt install curl -y
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN pwsh -c "Install-Module -Name PnP.PowerShell -Force -AllowPrerelease -Scope AllUsers;" 


RUN apt install golang-1.21 -y
ENV GOBIN="/usr/local/bin"
ENV PATH="/usr/lib/go-1.21/bin:${PATH}"

ENV KITCHEN_HOME="/kitchens"
RUN go install github.com/koksmat-com/koksmat@v2.1.1.15

WORKDIR /kitchens
COPY ./.koksmat/kitchenroot .
WORKDIR /kitchens/azure-users
COPY . .
WORKDIR /kitchens/azure-users/.koksmat/app

RUN go install




CMD [ "sleep","infinity"]