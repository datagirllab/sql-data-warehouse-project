# 📘 Naming Conventions

## General Principles

- **Naming Conventions**: Use `snake_case`, with lowercase letters and underscores (`_`) to separate words.
- **Language**: Use English for all names.
- **Avoid Reserved Words**: Do not use SQL reserved words as object names.

---

## Table Naming Conventions

### 🥉 Bronze Rules

All names must start with the source system name, and table names must match their original names without renaming.

**Format**: `<sourcesystem>_<entity>`

- `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
- `<entity>`: Exact table name from the source system.

**Example**:
- `crm_customer_info` → Customer information from the CRM system

---

### 🥈 Silver Rules

All names must start with the source system name, and table names must match their original names without renaming.

**Format**: `<sourcesystem>_<entity>`

- `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
- `<entity>`: Exact table name from the source system.

**Example**:
- `crm_customer_info` → Customer information from the CRM system

---

### 🥇 Gold Rules

All names must use meaningful, business-aligned names for tables, starting with the category prefix.

**Format**: `<category>_<entity>`

- `<category>`
