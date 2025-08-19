# Use official .NET SDK for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything and restore dependencies
COPY . .
RUN dotnet restore "./GenAIAPP.API.csproj"

# Build the project in Release mode
RUN dotnet publish "./GenAIAPP.API.csproj" -c Release -o /app/publish

# Use runtime-only image for final container
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Install ffmpeg if your app needs it
RUN apt-get update && apt-get install -y ffmpeg

# Copy published app
COPY --from=build /app/publish .

# Set environment variables (Render will override these)
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# Run the app
ENTRYPOINT ["dotnet", "GenAIAPP.API.dll"]
