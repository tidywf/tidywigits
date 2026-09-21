# CI/CD Workflow

``` mermaid
flowchart TD

    subgraph BUMP ["🔧 Bump Version"]
    B1["👾 Miniforge setup"]
    B2["🔖 Bump version"]
    B3["📦 Install from source"]
    B4["📖 Render README"]
    B5["💾 Commit and push"]
    B6["🔖 Create and push tag"]
    B1 --> B2
    B2 --> B3
    B3 --> B4
    B4 --> B5
    B5 --> B6
    end

    B6 --> J1S1

    subgraph DEPLOY ["🔧 Deploy"]
        direction TB
        subgraph prep ["📋 Version"]
        J1S1["📋 Version"]
        end
        subgraph condarise ["🐍 Condarise"]
        J2S1["🏷️ Set dev flags"]
        J2S2["👾 Miniforge setup"]
        J2S3["🐍 Conda pkg build"]
        J2S4["🐍 Conda pkg upload"]
        J2S5["🔒 Conda lock"]
        J2S6["📦 Publish lockfiles to release"]
        J2S1 --> J2S2
        J2S2 --> J2S3
        J2S3 --> J2S4
        J2S4 --> J2S5
        J2S5 --> J2S6
        end
        subgraph dockerise ["🐳 Dockerise"]
        J3S1["⬇️ Fetch lockfiles"]
        J3S2["🏰 QEMU setup"]
        J3S3["🏯 Buildx setup"]
        J3S4["🐙 GitHub CR login"]
        J3S5["🐳 Docker img build and push"]
        J3S1 --> J3S2
        J3S2 --> J3S3
        J3S3 --> J3S4
        J3S4 --> J3S5
        end
        subgraph pkgdownise ["🌐 Pkgdownise"]
        J4S1["👾 Miniforge setup"]
        J4S2["📦 Install from source"]
        J4S3["🌐 Website build"]
        J4S4["🚀 Website publish"]
        J4S1 --> J4S2
        J4S2 --> J4S3
        J4S3 --> J4S4
        end

        J1S1 --> J2S1
        J2S6 --> J3S1
        J3S5 --> J4S1
    end
```
