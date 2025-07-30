# Base image dùng để chạy app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Image để build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Chỉ copy file .csproj để restore, giúp tận dụng cache
COPY Ecommerce.csproj ./
RUN dotnet restore "Ecommerce.csproj"

# Sau khi restore xong mới copy toàn bộ source vào
COPY . . 

# Build và publish
RUN dotnet publish "Ecommerce.csproj" -c Release -o /app/publish --no-restore

# Final stage để chạy app
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Ecommerce.dll"]
