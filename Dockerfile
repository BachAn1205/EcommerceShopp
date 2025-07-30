# Use official ASP.NET Core runtime as base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
# Sao chép toàn bộ mã nguồn từ ngữ cảnh build vào thư mục /src
COPY . .

# Khôi phục các gói NuGet
# Vì Ecommerce.csproj nằm trực tiếp trong thư mục gốc của ngữ cảnh build,
# nó sẽ được sao chép vào /src/Ecommerce.csproj
RUN dotnet restore "Ecommerce.csproj"

# Đặt thư mục làm việc vào thư mục dự án để publish
# Vì .csproj nằm ở gốc, WORKDIR vẫn là /src
WORKDIR "/src"

# Publish ứng dụng
RUN dotnet publish "Ecommerce.csproj" -c Release -o /app/publish --no-restore

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Ecommerce.dll"]
