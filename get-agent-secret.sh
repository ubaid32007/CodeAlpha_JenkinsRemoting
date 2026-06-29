#!/bin/bash
# ──────────────────────────────────────────────────
# CodeAlpha DevOps Internship — Task 2
# Helper script: Get agent secret from Jenkins master
# Run this AFTER Jenkins master is up
# ──────────────────────────────────────────────────

JENKINS_URL="http://localhost:8080"
AGENT_NAME="codealpha-agent"
USER="admin"
PASS="admin123"

echo "=========================================="
echo "  Getting Jenkins Agent Secret"
echo "=========================================="

# Wait for Jenkins to be ready
echo "Waiting for Jenkins to start..."
until curl -s -o /dev/null -w "%{http_code}" "$JENKINS_URL/login" | grep -q "200"; do
    printf "."
    sleep 3
done
echo ""
echo "✅ Jenkins is up!"

# Get crumb for CSRF protection
CRUMB=$(curl -s "$JENKINS_URL/crumbIssuer/api/json" \
    --user "$USER:$PASS" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['crumb'])")

# Get agent secret
SECRET=$(curl -s "$JENKINS_URL/computer/$AGENT_NAME/slave-agent.jnlp" \
    --user "$USER:$PASS" | grep -oP '(?<=<argument>)[a-f0-9]{64}(?=</argument>)')

if [ -z "$SECRET" ]; then
    echo ""
    echo "⚠️  Could not auto-fetch secret. Get it manually:"
    echo ""
    echo "  1. Open: $JENKINS_URL/computer/$AGENT_NAME/"
    echo "  2. Click 'codealpha-agent'"
    echo "  3. Copy the secret key shown"
    echo "  4. Run: export AGENT_SECRET=<paste-secret-here>"
    echo "  5. Run: docker-compose up jenkins-agent"
else
    echo ""
    echo "✅ Agent Secret: $SECRET"
    echo ""
    echo "Now run:"
    echo "  export AGENT_SECRET=$SECRET"
    echo "  docker-compose up jenkins-agent"
fi
