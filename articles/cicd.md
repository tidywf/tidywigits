# CI/CD Workflow

``` mermaid
flowchart TD

    subgraph BUMP ["🔧 Bump Version"]
    B1["👾 Miniforge setup"]
    B2["🔖 Bump version"]
    B3["📦 Install from source"]
    B4["📖 Render README"]
    B5["💾 Commit and push"]
    B1 --> B2
    B2 --> B3
    B3 --> B4
    B4 --> B5
    end

    BUMP --> DEPLOY

    subgraph DEPLOY ["🔧 Deploy"]
        direction TB
        subgraph version ["📋 Get version"]
        end
        subgraph condarise ["🐍 Condarise"]
        J2S1["🏷️ Set dev flags"]
        J2S2["👾 Miniforge setup"]
        J2S3["🐍 Conda pkg build"]
        J2S4["🐍 Conda pkg upload"]
        J2S5["🔒 Conda lock"]
        J2S6["💾 Commit lockfiles"]
        J2S1 --> J2S2
        J2S2 --> J2S3
        J2S3 --> J2S4
        J2S4 --> J2S5
        J2S5 --> J2S6
        end
        subgraph tag ["🔖 Tag"]
        J3S1["📥 Pull latest commits"]
        J3S2["🔖 Create tag"]
        J3S1 --> J3S2
        end
        subgraph dockerise ["🐳 Dockerise"]
        J4S1["🏰 QEMU setup"]
        J4S2["🏯 Buildx setup"]
        J4S3["🐙 GitHub CR login"]
        J4S4["🐳 Docker img build and push"]
        J4S1 --> J4S2
        J4S2 --> J4S3
        J4S3 --> J4S4
        end
        subgraph pkgdownise ["🌐 Pkgdownise"]
        J5S1["👾 Miniforge setup"]
        J5S2["📦 Install from source"]
        J5S3["🌐 Website build"]
        J5S4["🚀 Website publish"]
        J5S1 --> J5S2
        J5S2 --> J5S3
        J5S3 --> J5S4
        end

        version --> condarise
        J2S6 --> J3S1
        J3S2 --> J4S1
        J4S4 --> J5S1
    end
```
