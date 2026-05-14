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

    B5 --> J1S1

    subgraph DEPLOY ["🔧 conda-docs"]
        subgraph condarise ["🐍 Condarise"]
        J1S1["👾 Miniforge setup"]
        J1S2["🐍 Conda pkg build"]
        J1S3["🐍 Conda pkg upload"]
        J1S4["🔒 Conda lock"]
        J1S5["💾 Commit lockfiles"]
        J1S1 --> J1S2
        J1S2 --> J1S3
        J1S3 --> J1S4
        J1S4 --> J1S5
        end
        subgraph tag ["🔖 Tag"]
        J2S1["📥 Pull latest commits"]
        J2S2["🔖 Create tag"]
        J2S1 --> J2S2
        end
        subgraph dockerise ["🐳 Dockerise"]
        J3S1["🏰 QEMU setup"]
        J3S2["🏯 Buildx setup"]
        J3S3["🐙 GitHub CR login"]
        J3S4["🐳 Docker img build and push"]
        J3S1 --> J3S2
        J3S2 --> J3S3
        J3S3 --> J3S4
        end
        subgraph pkgdownise ["🌐 Pkgdownise"]
        J4S1["👾 Miniforge setup"]
        J4S2["📦 Install from source"]
        J4S3["🌐 Website publish"]
        J4S1 --> J4S2
        J4S2 --> J4S3
        end

        J1S5 --> J2S1
        J2S2 --> J3S1
        J3S4 --> J4S1
    end
```
