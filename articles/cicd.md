# CI/CD Workflow

``` mermaid
flowchart TD
    classDef trigger font-weight:bold
    classDef warn fill:#fff3cd,stroke:#e0a800

    subgraph W1["bumpversion"]
        direction TB
        W1T(["▶️ manual dispatch"]):::trigger
        W1J1["<b>bump</b><br>✅ Validate version<br>🗄️ DVC pull<br>🔖 Bump version<br>📦 Install from source<br>📖 Render README<br>💾 Commit and push<br>🔖 Create and push tag"]
        W1T --> W1J1
    end

    subgraph W2["conda-docker-docs"]
        direction TB
        W2T(["▶️ tag push"]):::trigger
        W2J1["<b>📋 Version</b>"]
        W2J2["<b>🐍 Condarise</b><br>🏷️ Set dev flags<br>🐍 Conda pkg build<br>🐍 Conda pkg upload<br>🔒 Conda lock<br>📦 Publish lockfiles to release"]
        W2J3["<b>🐳 Dockerise</b><br>⬇️ Fetch lockfiles<br>🏷️ Image metadata<br>📛 Image name<br>🐳 Docker img build and push (by digest)<br>🧾 Export digest<br>⬆️ Upload digest<br>⬇️ Download digests<br>🏷️ Image metadata<br>🐳 Docker manifest list create and push"]
        W2J4["<b>🌐 Pkgdownise</b><br>🗄️ DVC pull<br>📦 Install from source<br>🌐 Website build<br>🚀 Website publish"]
        W2T --> W2J1
        W2J1 --> W2J2
        W2J2 --> W2J3
        W2J2 --> W2J4
    end
    W1 -.-> W2T
```
