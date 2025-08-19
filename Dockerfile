# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY ["GenAIAPP.api.csproj", "./"]
RUN dotnet restore "./GenAIAPP.api.csproj"

# Copy everything else and build
COPY . .
RUN dotnet build "GenAIAPP.api.csproj" -c Release -o /app/build
RUN dotnet publish "GenAIAPP.api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "GenAIAPP.api.dll"]
