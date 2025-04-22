# Self-hosted AI starter kit

**Self-hosted AI Starter Kit** is an open-source Docker Compose template designed to swiftly initialize a comprehensive local AI, chatbot UI, and low-code development environment.

![n8n.io - Screenshot](https://raw.githubusercontent.com/n8n-io/self-hosted-ai-starter-kit/main/assets/n8n-demo.gif)

Curated by <https://github.com/n8n-io>, it combines the self-hosted n8n
platform with a curated list of compatible AI products and components to
quickly get started with building self-hosted AI workflows.

> [!TIP]
> [Read the announcement](https://blog.n8n.io/self-hosted-ai/)

### What’s included

✅ [**Self-hosted n8n**](https://n8n.io/) - Low-code platform with over 400
integrations and advanced AI components

✅ [**Ollama**](https://ollama.com/) - Cross-platform LLM platform to install
and run the latest local LLMs

✅ [**Qdrant**](https://qdrant.tech/) - Open-source, high performance vector
store with a comprehensive API

✅ [**PostgreSQL**](https://www.postgresql.org/) - Workhorse of the Data
Engineering world, handles large amounts of data safely.

✅ [**LibreChat**](https://github.com/danny-avila/LibreChat) - Open-source ChatGPT-style web UI with multi-agent support, fine-tuned LLM compatibility, and chatbot pipelines.

✅ [**Valkey**](https://valkey.io/) - Drop-in replacement for Redis, serving as a fast key-value store, backing session storage and pub/sub capabilities.

### What you can build

⭐️ **AI Agents** for scheduling appointments

⭐️ **Summarize Company PDFs** securely without data leaks

⭐️ **Smarter Slack Bots** for enhanced company communications and IT operations

⭐️ **Private Financial Document Analysis** at minimal cost

⭐️ **Chat UI over Local LLMs** with persistent multi-agent workflows

## Integration with LibreChat

LibreChat is included as a first-class UI for chatting with local models and agents. This stack supports a LibreChat pipe module to interface with n8n workflows directly.

The LibreChat pipe connects a chat session to your n8n backend, sending messages and receiving structured responses. This enables building **chat-based workflows** using the n8n editor and LibreChat as a frontend.

To enable the pipe:
1. Install the `n8n_pipe` module inside the LibreChat backend under `pipes/n8n_pipe.py`
2. Update the `agent.yaml` to include a pipe entry referencing `n8n_pipe`
3. Make sure your webhook URL, bearer token, and input/output field names match your n8n configuration

> ℹ️ The `n8n_pipe` class is adapted from the original by Cole Medin. 
> For an Ollama-friendly version hosted by Cole, see: [https://openwebui.com/f/coleam/n8n_pipe](https://openwebui.com/f/coleam/n8n_pipe)

## Installation

### Cloning the Repository

```bash
git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git
cd self-hosted-ai-starter-kit
```

### Running with Docker Compose

Profiles:
- `gpu-nvidia` — for systems with Nvidia GPU and GPU-compatible Ollama
- `gpu-amd` — for AMD GPU support on Linux
- `cpu` — general fallback for Mac, WSL, or CPU-only systems

For Nvidia:
```bash
docker compose --profile gpu-nvidia up
```

For AMD:
```bash
docker compose --profile gpu-amd up
```

For CPU:
```bash
docker compose --profile cpu up
```

### LibreChat + Valkey Additions

Make sure your Docker Compose file includes services for LibreChat and Valkey:

```yaml
  librechat:
    image: librechat/librechat:latest
    ports:
      - "3080:3080"
    environment:
      - REDIS_HOST=valkey
      - REDIS_PORT=6379
    depends_on:
      - valkey

  valkey:
    image: valkey/valkey:latest
    ports:
      - "6379:6379"
```

After the stack is up, open:
- n8n: [http://localhost:5678](http://localhost:5678)
- LibreChat: [http://localhost:3080](http://localhost:3080)

## Quick Start

1. Open n8n and set up your first workflow (e.g., text classification or retrieval)
2. Connect it to LibreChat using the `n8n_pipe` plugin
3. Interact with your workflow through the LibreChat frontend

## Attribution

The original concept for the `n8n_pipe` was created by [Cole Medin](https://www.youtube.com/@ColeMedin). This project builds on that foundation to integrate with LibreChat as a full-stack AI agent chat and automation environment.

## License

This project is licensed under the Apache License 2.0 - see the
[LICENSE](LICENSE) file for details.

## Support

For n8n questions: [n8n Forum](https://community.n8n.io/)

For LibreChat questions: [LibreChat GitHub Discussions](https://github.com/danny-avila/LibreChat/discussions)
