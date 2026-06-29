# Task 2: Jenkins Remoting Project
## CodeAlpha DevOps Internship

A fully functional Jenkins setup with a **Master node** and a **remote Agent node** connected via JNLP (Jenkins Remoting). Build jobs are distributed from the master to the remote agent securely.

---

## Architecture

```
┌─────────────────────────────────────────────┐
│              Docker Network                  │
│                                             │
│  ┌──────────────────┐    JNLP Port 50000    │
│  │  Jenkins Master  │◄──────────────────────┤
│  │  (Controller)    │                       │
│  │  Port: 8080      │    ┌────────────────┐ │
│  │                  │───►│ Jenkins Agent  │ │
│  │  - Manages jobs  │    │ (Remote Node)  │ │
│  │  - UI dashboard  │    │                │ │
│  │  - Schedules     │    │ - Runs builds  │ │
│  │    builds        │    │ - Isolated     │ │
│  └──────────────────┘    │ - 2 executors  │ │
│                          └────────────────┘ │
└─────────────────────────────────────────────┘
         │
         ▼
   Your Browser
   http://localhost:8080
```

---

## Project Structure
```
CodeAlpha_JenkinsRemoting/
├── master/
│   ├── Dockerfile                        # Jenkins master container
│   ├── plugins.txt                       # Auto-installed plugins
│   └── init.groovy.d/
│       ├── 01-create-admin.groovy        # Auto-creates admin user
│       └── 02-register-agent.groovy      # Auto-registers agent node
├── agent/
│   └── Dockerfile                        # Jenkins agent container
├── jobs/
│   └── sample-job/
│       └── Jenkinsfile                   # Pipeline job (runs on agent)
├── scripts/
│   └── get-agent-secret.sh              # Helper to fetch agent secret
├── docker-compose.yml                    # Orchestrates master + agent
└── README.md
```

---

## Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running

---

## Step-by-Step Setup

### Step 1 — Start Jenkins Master first
```bash
docker-compose up --build jenkins-master
```
Wait until you see `Jenkins is fully up and running` in the logs (~2 minutes).

### Step 2 — Open Jenkins UI
Go to: **http://localhost:8080**
Login with:
- **Username:** `admin`
- **Password:** `admin123`

### Step 3 — Get the Agent Secret
1. In Jenkins UI → click **"Manage Jenkins"**
2. Click **"Manage Nodes and Clouds"**
3. Click **"codealpha-agent"**
4. You will see a command like:
   ```
   java -jar agent.jar -url http://... -secret <SECRET_HERE> -name codealpha-agent
   ```
5. Copy that **secret key**

### Step 4 — Start the Agent
Open a new terminal in the same folder:
```bash
# Windows (Command Prompt)
set AGENT_SECRET=<paste-secret-here>
docker-compose up --build jenkins-agent

# Windows (PowerShell)
$env:AGENT_SECRET="<paste-secret-here>"
docker-compose up --build jenkins-agent

# Linux / Mac
export AGENT_SECRET=<paste-secret-here>
docker-compose up --build jenkins-agent
```

### Step 5 — Verify Agent is Connected
1. Go to **http://localhost:8080/computer/**
2. You should see **codealpha-agent** with status ✅ **"In sync"**

### Step 6 — Run a Pipeline Job on the Agent
1. In Jenkins UI → **"New Item"**
2. Name: `CodeAlpha-Task2-Pipeline`
3. Select **"Pipeline"** → click OK
4. Scroll to **Pipeline** section
5. Paste the contents of `jobs/sample-job/Jenkinsfile`
6. Click **Save** → Click **"Build Now"**
7. Watch the job run on the **remote agent** 🎉

---

## Key Concepts Demonstrated

| Concept | How It's Done |
|---|---|
| Jenkins Remoting | JNLP agent connects to master on port 50000 |
| Distributed builds | Pipeline uses `agent { label 'agent' }` |
| Node isolation | Agent runs in separate container/network |
| Security | CSRF protection, credentials, isolated node |
| Auto-configuration | Groovy init scripts configure master on startup |
| Plugin management | `plugins.txt` auto-installs all required plugins |
| Health monitoring | Docker healthcheck on master container |
| Persistent storage | Docker volumes for Jenkins home + workspace |

---

## Useful Commands

```bash
# Start everything
docker-compose up --build

# View master logs
docker logs jenkins-master -f

# View agent logs
docker logs jenkins-agent -f

# Check container status
docker ps

# Stop everything
docker-compose down

# Stop and delete all data (fresh start)
docker-compose down -v
```

---

## Troubleshooting

**Agent shows "offline" in Jenkins UI?**
- Make sure you set the correct `AGENT_SECRET`
- Check agent logs: `docker logs jenkins-agent`

**Port 8080 already in use?**
- Change `"8080:8080"` to `"9090:8080"` in docker-compose.yml

**Jenkins takes too long to start?**
- Normal — first startup installs ~15 plugins. Wait 3-4 minutes.

---

**CodeAlpha DevOps Internship | Task 2: Jenkins Remoting Project**
