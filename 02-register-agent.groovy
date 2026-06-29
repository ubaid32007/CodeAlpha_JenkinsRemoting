// ──────────────────────────────────────────────────
// Auto-register remote agent node on Jenkins master
// CodeAlpha DevOps Internship — Task 2
// ──────────────────────────────────────────────────

import jenkins.model.*
import hudson.model.*
import hudson.slaves.*
import hudson.plugins.sshslaves.*
import hudson.slaves.EnvironmentVariablesNodeProperty
import hudson.slaves.EnvironmentVariablesNodeProperty.Entry

def instance = Jenkins.getInstance()

// Wait a moment for instance to fully start
Thread.sleep(3000)

// Check if agent already registered
if (instance.getNode("codealpha-agent") != null) {
    println "ℹ️  Agent 'codealpha-agent' already exists, skipping."
    return
}

// Define the remote agent node
def launcher = new JNLPLauncher(true)

def agent = new DumbSlave(
    "codealpha-agent",                          // Node name
    "/home/jenkins/agent",                      // Remote root directory
    launcher
)

agent.setNumExecutors(2)                        // 2 parallel builds
agent.setLabelString("agent linux docker")      // Labels for job targeting
agent.setMode(Node.Mode.NORMAL)
agent.setRetentionStrategy(new RetentionStrategy.Always())

// Add environment variables to agent
def envVars = new EnvironmentVariablesNodeProperty(
    new Entry("AGENT_NAME", "codealpha-agent"),
    new Entry("ENVIRONMENT", "CodeAlpha-DevOps")
)
agent.getNodeProperties().add(envVars)

instance.addNode(agent)
instance.save()

println "✅ Agent node 'codealpha-agent' registered successfully"
println "   Executors : 2"
println "   Labels    : agent linux docker"
println "   Root Dir  : /home/jenkins/agent"
