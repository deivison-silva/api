# 📱 API REST - Flutter & Mock Server Workspace

Este repositório contém uma aplicação **Flutter** integrada a um **Mock REST API Server** (`json-server`) com persistência local em arquivo JSON. O ambiente foi planejado para simular consumo de APIs RESTful completas com suporte a latência de rede e resolução automática de endereçamento por plataforma (Android, iOS, Web e Desktop).

---

## 🏗️ Estrutura do Repositório

O projeto é estruturado em formato de workspace unificado:

```text
├── android/            # Configurações nativas Android
├── lib/                # Código-fonte do aplicativo Flutter
│   ├── api/            # Configurações de rede e base URL dinâmica (ApiConfig)
│   ├── models/         # Modelos de dados com serialização (Posts, Comments, Todos)
│   ├── service/        # Camada de comunicação HTTP utilizando Dio
│   └── main.dart       # Ponto de entrada e UI com FutureBuilder
├── server/             # API REST Mock (Node.js + json-server)
│   ├── db.json         # Base de dados mockada (persistente)
│   ├── package.json    # Configurações e scripts do json-server
│   └── public/         # Arquivos estáticos / documentação da API
├── package.json        # Scripts de conveniência para gerenciar o servidor pela raiz
└── pubspec.yaml        # Dependências do Flutter (Dio, etc.)
```

---

## ⚙️ Pré-requisitos

Antes de iniciar, certifique-se de ter instalado em sua máquina:

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão `>= 3.0.0`)
* [Node.js](https://nodejs.org/) (versão `>= 16.x`) e **npm**
* Emulador Android, simulador iOS, dispositivo físico ou navegador configurado

---

## 🚀 Como Executar o Projeto

A execução requer **dois terminais**: um para o servidor mock e outro para o aplicativo Flutter.

### 1️⃣ Inicializando a API Mock (Terminal 1)

Na raiz do repositório, instale as dependências do servidor e execute o serviço:

```bash
# Instala as dependências do mock server (apenas na primeira vez)
npm run setup

# Inicia a API REST mock na porta 3000
npm start
```

> **Nota:** A API roda por padrão em `http://0.0.0.0:3000` com um delay artificial de **500ms** para permitir a visualização de estados de carregamento (`CircularProgressIndicator`) no app.

---

### 2️⃣ Executando o Aplicativo Flutter (Terminal 2)

Em outro terminal na raiz do projeto:

```bash
# Obtenha as dependências do Flutter
flutter pub get

# Execute a aplicação no dispositivo/emulador desejado
flutter run
```

---

## 🌐 Resolução de Rede & Plataformas

O arquivo [`lib/api/api_config.dart`](file:///home/deivison/dev/api_rest/lib/api/api_config.dart) detecta automaticamente a plataforma para rotear as requisições corretamente:

| Ambiente / Plataforma | Endereço Resolvido | Observações |
| :--- | :--- | :--- |
| **Navegador Web (Chrome/Edge)** | `http://localhost:3000` | Funciona nativamente |
| **Desktop (Linux/macOS/Windows)** | `http://localhost:3000` | Funciona nativamente |
| **Simulador iOS** | `http://localhost:3000` | O simulador compartilha o localhost do host |
| **Emulador Android** | `http://10.0.2.2:3000` | O alias `10.0.2.2` mapeia para o localhost da máquina host |
| **Dispositivo Físico Android (via USB)** | `http://localhost:3000` | **Requer redirecionamento via ADB** (veja abaixo) |

### ⚠️ Atenção ao rodar em Dispositivo Físico via USB
Se for executar em um celular Android físico conectado via cabo USB, execute o comando abaixo no terminal da sua máquina para redirecionar a porta 3000 do aparelho para o seu computador:

```bash
adb reverse tcp:3000 tcp:3000
```

---

## 📡 Endpoints Disponíveis na API Mock

A API simula o conjunto de recursos padrão do JSONPlaceholder com persistência em tempo real no arquivo [`server/db.json`](file:///home/deivison/dev/api_rest/server/db.json):

* `GET /posts` - Listar postagens
* `GET /posts/:id` - Buscar postagem por ID
* `GET /comments` - Listar comentários
* `GET /todos` - Listar tarefas
* `GET /users` - Listar usuários
* `GET /albums` - Listar álbuns
* `GET /photos` - Listar fotos

> Qualquer operação `POST`, `PUT`, `PATCH` ou `DELETE` terá persistência salva automaticamente no arquivo `server/db.json`.

---

## 🛠️ Tecnologias Utilizadas

* **Flutter & Dart**: Interface reativa e arquitetura de componentes.
* **Dio**: Cliente HTTP robusto para consumo de APIs.
* **JSON-Server**: Mock REST API veloz com suporte a persistência e middlewares.
* **FutureBuilder**: Gerenciamento nativo de ciclo de vida e estados de requisições assíncronas.
