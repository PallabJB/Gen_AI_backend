# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Build image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy csproj and restore (⚡ no folder, just file)

COPY ["GenAIAPP.api/GenAIAPP.api/GenAIAPP.api.csproj", "GenAIAPP.api/"]
RUN dotnet restore "./GenAIAPP.api/GenAIAPP.api.csproj"


# Copy everything else
COPY . .
WORKDIR "/src"
RUN dotnet build "./GenAIAPP.api.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./GenAIAPP.api.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GenAIAPP.api.dll"]
