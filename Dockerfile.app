FROM mcr.microsoft.com/azure-cli

RUN apk update
RUN apk add --upgrade powershell   
RUN pwsh -c "Install-Module -Name PnP.PowerShell -Force -AllowPrerelease -Scope AllUsers;" 

RUN apk add go

# Install module azuread
ENV KITCHEN_HOME="/kitchens"
RUN go install github.com/koksmat-com/koksmat@v2.1.1.15

WORKDIR /kitchens
COPY ./.koksmat/kitchenroot .
WORKDIR /kitchens/azure-users
COPY . .
WORKDIR /kitchens/azure-users/.koksmat/app

RUN go install




CMD [ "sleep","infinity"]

