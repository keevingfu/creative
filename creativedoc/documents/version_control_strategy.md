# 版本控制策略

## 概述

本文档定义了AI创意大脑项目的版本控制策略，旨在规范团队协作流程，确保代码质量和项目稳定性。

## 版本号规范

项目采用语义化版本控制（Semantic Versioning），格式为：X.Y.Z

- X: 主版本号。当进行不兼容的API修改时增加。
- Y: 次版本号。当增加向下兼容的功能时增加。
- Z: 修订号。当进行向下兼容的问题修复时增加。

前置标识符如alpha、beta、rc等可用于发布前的版本，如1.0.0-beta.1。

## 分支策略

项目采用Git Flow工作流，包含以下分支类型：

### 主要分支

- `main`: 生产环境分支，包含稳定、可部署的代码。
- `develop`: 开发分支，包含最新的开发代码，作为功能分支的集成点。

### 辅助分支

- `feature/*`: 功能开发分支，从`develop`分支创建，完成后合并回`develop`。
- `release/*`: 发布准备分支，从`develop`分支创建，完成后合并到`main`和`develop`。
- `hotfix/*`: 热修复分支，从`main`分支创建，修复生产环境问题，完成后合并到`main`和`develop`。

## 提交规范

提交信息格式采用Conventional Commits规范：

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 类型（Type）

- `feat`: 新功能
- `fix`: 错误修复
- `docs`: 文档修改
- `style`: 代码格式修改，不影响代码功能
- `refactor`: 代码重构，既不修复错误也不添加功能
- `perf`: 性能优化
- `test`: 添加或修改测试代码
- `build`: 影响构建系统或外部依赖的修改
- `ci`: 持续集成配置或脚本修改
- `chore`: 其他不修改src或test的修改

### 示例

```
feat(creative): 添加四象限分析功能

实现了基于已知已知、已知未知、未知已知、未知未知的四象限创意分析功能。

Resolves: #123
```

## 工作流程

1. 从JIRA或项目管理工具中领取任务
2. 从`develop`分支创建功能分支：`git checkout -b feature/功能名称`
3. 在功能分支进行开发和提交
4. 完成功能后，创建Pull Request到`develop`分支
5. 代码审查通过后，合并到`develop`分支
6. 当准备发布新版本时，从`develop`创建`release`分支
7. 在`release`分支进行最终测试和修复
8. 测试通过后，将`release`分支合并到`main`和`develop`分支
9. 在`main`分支打标签，创建新版本

## 发布流程

1. 确认所有计划功能已完成并合并到`develop`分支
2. 创建`release/vX.Y.Z`分支
3. 在`release`分支更新版本号、CHANGELOG.md
4. 进行回归测试，修复问题
5. 测试通过后，合并到`main`和`develop`分支
6. 在`main`分支创建标签：`git tag -a vX.Y.Z -m "Version X.Y.Z"`
7. 推送标签：`git push origin vX.Y.Z`
8. 触发CI/CD流程，部署到生产环境

## 冲突解决

当遇到合并冲突时，遵循以下原则：

1. 保持功能完整性和正确性
2. 尊重原代码风格和架构
3. 如有疑问，与相关代码作者讨论解决方案
4. 解决冲突后经过测试确认功能正常

## 代码审查

所有进入`develop`和`main`分支的代码必须经过代码审查，审查重点：

1. 代码质量和风格
2. 功能完整性和正确性
3. 测试覆盖率
4. 文档完善度
5. 安全性考虑

## 工具和集成

- Git: 版本控制系统
- GitHub: 代码托管平台
- GitHub Actions: CI/CD自动化
- ESLint & Prettier: 代码规范和格式化
- Jest: 单元测试框架
- Husky: Git提交钩子

---

本策略文档将随项目发展不断完善，团队成员应定期查阅最新版本。