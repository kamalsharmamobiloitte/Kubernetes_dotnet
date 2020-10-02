FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["Kubernetes_Dotnet.csproj", "./"]

RUN dotnet restore "./Kubernetes_Dotnet.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Kubernetes_Dotnet.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Kubernetes_Dotnet.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Kubernetes_Dotnet.dll"]