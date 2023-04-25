FROM mcr.microsoft.com/dotnet/runtime:7.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["FM6.csproj", "./"]
RUN dotnet restore "FM6.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "FM6.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FM6.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FM6.dll"]
