# Salesforce DX Project: sf_proj

## Project Overview

This is a **Salesforce DX (SFDX)** project configured for developing Salesforce applications using modern source-driven development practices. The project uses API version 65.0 and follows the standard Salesforce DX directory structure.

### Key Technologies

- **Salesforce DX** - Source-driven development tooling
- **Lightning Web Components (LWC)** - Modern web component framework
- **Apex** - Server-side logic and triggers
- **SOQL** - Salesforce Object Query Language
- **JavaScript/Node.js** - LWC development and tooling

### Project Structure

```
sf_proj/
├── force-app/                  # Main package directory
│   └── main/default/           # Default package metadata
│       ├── applications/       # Salesforce applications
│       ├── aura/               # Aura components (legacy)
│       ├── classes/            # Apex classes
│       ├── contentassets/      # Content assets
│       ├── flexipages/         # Lightning pages
│       ├── layouts/            # Object layouts
│       ├── lwc/                # Lightning Web Components
│       ├── objects/            # Custom objects & fields
│       ├── permissionsets/     # Permission sets
│       ├── staticresources/    # Static resources (CSS, JS, images)
│       ├── tabs/               # Custom tabs
│       └── triggers/           # Apex triggers
├── config/                     # Configuration files
│   └── project-scratch-def.json # Scratch org definition
├── scripts/                    # Utility scripts
│   ├── apex/                   # Anonymous Apex scripts
│   └── soql/                   # SOQL query files
├── .vscode/                    # VS Code settings
├── .husky/                     # Git hooks
└── .sfdx/                      # SFDX tooling
```

---

## Building and Running

### Prerequisites

- [Salesforce CLI](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Node.js](https://nodejs.org/) (v18 or later recommended)
- [VS Code](https://code.visualstudio.com/) with Salesforce Extensions

### Installation

```bash
# Install dependencies
npm install
```

### Development Commands

| Command                      | Description                    |
| ---------------------------- | ------------------------------ |
| `npm run lint`               | Lint LWC JavaScript files      |
| `npm run test`               | Run unit tests                 |
| `npm run test:unit`          | Run LWC Jest tests             |
| `npm run test:unit:watch`    | Run tests in watch mode        |
| `npm run test:unit:debug`    | Run tests with debugger        |
| `npm run test:unit:coverage` | Run tests with coverage report |
| `npm run prettier`           | Format all supported files     |
| `npm run prettier:verify`    | Verify formatting (CI check)   |

### Salesforce DX Workflow

#### Deployment Priority

### MCP Tools (Primary - always try these first)

- 'deploy_metadata' - Deploy source to an org
- 'retrieve_metadata' - Retrieve source from an org
- 'run_apex_test' - Run Apex tests
- 'run_agent_test' - Run Agent tests
- 'run_soql_query' - Execute SOQL queries
- 'assign_permission_set' - Assign permission sets

**ALWAYS use Salesforce MCP tools first** for all org operations (deploy, retrieve, query, etc.). Only fall back to `sf` CLI commands if the MCP tools fail or are unavailable.

```bash
# Create a scratch org
sf org create scratch -f config/project-scratch-def.json -a my-scratch

# Push source to scratch org
sf project deploy start

# Pull source from scratch org
sf project retrieve start

# Execute anonymous Apex
sf apex run -f scripts/apex/hello.apex

# Execute SOQL query
sf data query -q "SELECT Id, Name FROM Account"
```

---

## Development Conventions

### Code Formatting

- **Prettier** with `prettier-plugin-apex` and `@prettier/plugin-xml`
- Trailing commas: **none**
- Auto-formatted on commit via husky pre-commit hook
- Supported file types: `.cls`, `.cmp`, `.component`, `.css`, `.html`, `.js`, `.json`, `.md`, `.page`, `.trigger`, `.xml`, `.yaml`, `.yml`

### Linting

- **ESLint** with Salesforce LWC configurations
- Linting runs on commit for `**/{aura,lwc}/**/*.js` files
- Plugins: `@lwc/eslint-plugin-lwc`, `@salesforce/eslint-plugin-aura`, `@salesforce/eslint-plugin-lightning`

### Git Hooks

- **Husky** pre-commit hook runs `lint-staged`
- Staged files are automatically formatted and linted before commit

### Testing

- **Jest** via `@salesforce/sfdx-lwc-jest`
- Test files located in `__tests__` directories within LWC components
- Tests excluded from source push/pull operations (see `.forceignore`)

### VS Code Extensions (Recommended)

- `salesforce.salesforcedx-vscode` - Salesforce DX tools
- `redhat.vscode-xml` - XML support
- `dbaeumer.vscode-eslint` - ESLint integration
- `esbenp.prettier-vscode` - Prettier formatting
- `financialforce.lana` - Apex debugging

---

## File Conventions

### `.apex` Files

Store anonymous Apex scripts. Execute in VS Code:

- **Selected text**: `SFDX: Execute Anonymous Apex with Currently Selected Text`
- **Entire file**: `SFDX: Execute Anonymous Apex with Editor Contents`

### `.soql` Files

Store SOQL queries. Execute in VS Code:

- **Selected text**: `SFDX: Execute SOQL Query with Currently Selected Text`

---

## Configuration Files

### `sfdx-project.json`

- **Package Directory**: `force-app` (default)
- **API Version**: 65.0
- **Namespace**: None (unlocked package model)

### `config/project-scratch-def.json`

- **Edition**: Developer
- **Features**: EnableSetPasswordInApi
- **Settings**: Lightning Experience enabled, S1 Desktop enabled

### `.forceignore`

Excludes from source operations:

- `package.xml`
- LWC config files (`jsconfig.json`, `.eslintrc.json`)
- Test directories (`__tests__/`)

---

## General Rules

# Agent Script Rules & Guide

This document provides comprehensive rules and guidance for building valid Agent Script configurations (`.agent` files).

---

## Discovery Questions

Before writing Agent Script, work through these questions to understand requirements:

### 1. Agent Identity & Purpose

- **What is the agent's name?** (letters, numbers, underscores only; no spaces; max 80 chars)
- **What is the agent's primary purpose?** (This becomes the description)
- **What personality should the agent have?** (Friendly, professional, formal, casual?)
- **What should the welcome message say?**
- **What should the error message say?**

### 2. Topics & Conversation Flow

- **What distinct conversation areas (topics) does this agent need?**
- **What is the entry point topic?** (The first topic users interact with)
- **How should the agent transition between topics?**
- **Are there any topics that need to delegate to other topics and return?**

### 3. State Management

- **What information needs to be tracked across the conversation?**
  - User data (name, email, preferences)?
  - Process state (step completed, status)?
  - Collected inputs (selections, answers)?
- **What external context is needed?** (session ID, user record, etc.)

### 4. Actions & External Systems

- **What external systems does the agent need to call?**
  - Salesforce Flows
  - Apex classes
  - Prompt templates
  - External APIs
- **For each action:**
  - What inputs does it need?
  - What outputs does it return?
  - When should it be available?

### 5. Reasoning & Instructions

- **What should the agent do in each topic?**
- **Are there conditions that change the instructions?**
- **Should any actions run automatically before/after reasoning?**

---

## Lifecycle Operations

### Validating Agent Script

ALWAYS run this CLI command after modifying `.agent` files to validate your changes.

```bash
sf agent validate authoring-bundle --api-name NAME_OF_AGENT_FILE_WITHOUT_EXTENSION
```

### Deployment Considerations

- NEVER deploy `.agent` or `AiAuthoringBundle` metadata unless explicitly asked to do so
- ALWAYS deploy `ApexClass` metadata when you create or modify `.cls` Apex class files

---

## File Structure & Block Ordering

Top-level blocks MUST appear in this order:

```agentscript
# 1. SYSTEM (required) - Global instructions and messages
system:
    instructions: "..."
    messages:
        welcome: "..."
        error: "..."

# 2. CONFIG (required) - Agent metadata
config:
    agent_name: "DescriptiveName"
    ...

# 3. VARIABLES (optional) - State management
variables:
    ...

# 4. CONNECTIONS (optional) - Escalation routing
connections:
    ...

# 5. KNOWLEDGE (optional) - Knowledge base config
knowledge:
    ...

# 6. LANGUAGE (optional) - Locale settings
language:
    ...

# 7. START_AGENT (required) - Entry point
start_agent topic_selector:
    description: "..."
    reasoning:
        instructions: ->
            ...
        actions:
            ...

# 8. TOPICS (at least one required)
topic my_topic:
    description: "..."
    reasoning:
        ...
    actions:
        ...
```

---

## Block Internal Ordering

### Within `start_agent` and `topic` blocks:

1. `description` (required)
2. `system` (optional - for instruction overrides)
3. `before_reasoning` (optional)
4. `reasoning` (required)
5. `after_reasoning` (optional)
6. `actions` (optional - action definitions)

### Within `reasoning` blocks:

1. `instructions` (required)
2. `actions` (optional)

---

## Required Elements

Every Agent Script MUST have:

- `config` block with `agent_name`
- `system` block with `messages.welcome`, `messages.error`, and `instructions`
- `start_agent` block with `description` and `reasoning.actions`
- At least one `topic` block with `description` and `reasoning`

---

## Naming Rules

All names (agent_name, topic names, variable names, action names):

- Can contain only letters, numbers, and underscores
- Must begin with a letter
- Cannot include spaces
- Cannot end with an underscore
- Cannot contain two consecutive underscores
- Maximum 80 characters

---

## Indentation & Comments

- Use spaces (not tabs)
- Recommended: 4 spaces per level
- Maintain consistent indentation throughout
- Use `#` for comments (Python-style)

```agentscript
# This is a comment
config:
    agent_name: "My_Agent"  # Inline comment
```

---

## Block Reference

### Config Block

```agentscript
config:
    # Required
    agent_name: "DescriptiveName"           # Unique identifier (letters, numbers, underscores)

    # Optional with defaults
    agent_label: "DescriptiveName"          # Display name (defaults to normalized agent_name)
    description: "Agent description"        # What the agent does
    agent_type: "AgentforceServiceAgent"    # or "AgentforceEmployeeAgent"
    default_agent_user: "user@example.com"  # Required for AgentforceServiceAgent
```

### Variables Block

```agentscript
variables:
    # MUTABLE variables - agent can read AND write (MUST have default value)
    my_string: mutable string = ""
        description: "Description for slot-filling"

    my_number: mutable number = 0

    my_bool: mutable boolean = False

    my_list: mutable list[string] = []

    my_object: mutable object = {}

    # LINKED variables - read-only from external context (MUST have source, NO default)
    session_id: linked string
        description: "The session ID"
        source: @session.sessionID
```

**Boolean variable values MUST be capitalized:**

- ALWAYS `True` or `False`
- NEVER `true` or `false`

**Type Support Matrix:**

| Type        | Mutable | Linked | Actions |
| ----------- | ------- | ------ | ------- |
| `string`    | ✅      | ✅     | ✅      |
| `number`    | ✅      | ✅     | ✅      |
| `boolean`   | ✅      | ✅     | ✅      |
| `object`    | ✅      | ❌     | ✅      |
| `date`      | ✅      | ✅     | ✅      |
| `timestamp` | ✅      | ✅     | ✅      |
| `currency`  | ✅      | ✅     | ✅      |
| `id`        | ✅      | ✅     | ✅      |
| `list[T]`   | ✅      | ❌     | ✅      |
| `datetime`  | ❌      | ❌     | ✅      |
| `time`      | ❌      | ❌     | ✅      |
| `integer`   | ❌      | ❌     | ✅      |
| `long`      | ❌      | ❌     | ✅      |

### System Block

```agentscript
system:
    messages:
        welcome: "Welcome message shown when conversation starts"
        error: "Error message shown when something goes wrong"

    # The | (pipe) indicates multiline prompt instructions before/after deterministic logic
    instructions: ->
        | You are a helpful assistant.
          Always be polite and professional.
          Never share sensitive information.
```

### Topic Block Structure

```agentscript
topic my_topic:
    description: "What this topic handles"

    # Optional: Override system instructions for this topic
    system:
        instructions: ->
            | Topic-specific system instructions

    # Action definitions (what the topic CAN call)
    actions:
        action_name:
            description: "What this action does"
            inputs:
                param1: string
                description: "Parameter description"
                param2: number
            outputs:
                result: string
            target: "flow://MyFlow"

    # Optional: Runs before each reasoning cycle
    before_reasoning:
        run @actions.some_action
            with param = @variables.value
            set @variables.result = @outputs.result

    # Required: Reasoning configuration
    reasoning:
        instructions:->
            | Static instructions that always appear
            if @variables.some_condition:
                | Conditional instructions
            | More instructions with template: {!@variables.value}

        # Actions available to the LLM during reasoning
        actions:
            action_alias: @actions.action_name
                description: "Override description"
                available when @variables.condition == True
                with param1 = ...           # LLM slot-fills this
                with param2 = @variables.x  # Bound to variable
                set @variables.y = @outputs.result

    # Optional: Runs after reasoning completes
    after_reasoning:
        if @variables.should_transition:
            transition to @topic.next_topic
```

---

## Action Definition

### Target Formats

| Short                     | Long                      | Use Case         |
| ------------------------- | ------------------------- | ---------------- |
| `flow`                    | `flow`                    | Salesforce Flow  |
| `apex`                    | `apex`                    | Apex Class       |
| `prompt`                  | `generatePromptResponse`  | Prompt Template  |
| `standardInvocableAction` | `standardInvocableAction` | Built-in Actions |
| `externalService`         | `externalService`         | External APIs    |
| `quickAction`             | `quickAction`             | Quick Actions    |
| `api`                     | `api`                     | REST API         |
| `apexRest`                | `apexRest`                | Apex REST        |

Additional types: `serviceCatalog`, `integrationProcedureAction`, `expressionSet`, `cdpMlPrediction`, `externalConnector`, `slack`, `namedQuery`, `auraEnabled`, `mcpTool`, `retriever`

### Full Action Syntax

```agentscript
actions:
    get_customer:
        target: "flow://GetCustomerInfo"
        description: "Fetches customer information"
        label: "Get Customer"
        require_user_confirmation: False
        include_in_progress_indicator: True
        progress_indicator_message: "Looking up customer..."
        inputs:
            customer_id: string
                description: "The customer's unique ID"
                label: "Customer ID"
                is_required: True
        outputs:
            name: string
                description: "Customer's name"
            email: string
                description: "Customer's email"
                filter_from_agent: False
                is_displayable: True
```

---

## Reasoning Actions

### Input Binding

```agentscript
reasoning:
    actions:
        # LLM slot-fills all parameters
        search: @actions.search_products
            with query = ...
            with category = ...

        # Mix of bound and slot-filled
        lookup: @actions.lookup_customer
            with customer_id = @variables.current_customer_id   # Bound
            with include_history = ...                          # LLM decides
            with limit = 10                                     # Fixed value
```

Use `...` to indicate LLM should extract value from conversation.

### Post-Action Directives

Only work with `@actions.*`, NOT with `@utils.*`:

```agentscript
reasoning:
    actions:
        process: @actions.process_order
            with order_id = @variables.order_id
            # Capture outputs
            set @variables.status = @outputs.status
            set @variables.total = @outputs.total
            # Chain another action
            run @actions.send_notification
                with message = "Order processed"
                set @variables.notified = @outputs.sent
            # Conditional transition
            if @outputs.needs_review:
                transition to @topic.review
```

### Utility Actions (reasoning.actions only)

| Utility                | Purpose               | Syntax                                          |
| ---------------------- | --------------------- | ----------------------------------------------- |
| `@utils.escalate`      | Escalate to human     | `name: @utils.escalate`                         |
| `@utils.transition to` | Permanent handoff     | `name: @utils.transition to @topic.X`           |
| `@utils.setVariables`  | Set variables via LLM | `name: @utils.setVariables` with `with var=...` |
| `@topic.<name>`        | Delegate (can return) | `name: @topic.X`                                |

```agentscript
reasoning:
    actions:
        # Transition to another topic (permanent handoff)
        go_to_checkout: @utils.transition to @topic.checkout
            description: "Move to checkout when ready"
            available when @variables.cart_has_items == True

        # Escalate to human
        get_help: @utils.escalate
            description: "Connect with a human agent"
            available when @variables.needs_human == True

        # Delegate to topic (can return)
        consult_expert: @topic.expert_topic
            description: "Consult the expert topic"

        # Set variables via LLM
        collect_info: @utils.setVariables
            description: "Collect user preferences"
            with preferred_color = ...
            with budget = ...
```

---

## Transition Syntax Rules

**CRITICAL: Different syntax depending on context!**

### In `reasoning.actions` (LLM-selected):

```agentscript
go_next: @utils.transition to @topic.target_topic
   description: "Description for LLM"
```

### In Directive Blocks (`before_reasoning`, `after_reasoning`):

```agentscript
transition to @topic.target_topic
```

- NEVER use `@utils.transition to` in directive blocks
- NEVER use bare `transition to` in `reasoning.actions`

---

## Control Flow

### If/Else in Instructions

```agentscript
instructions: ->
    | Welcome to the assistant!

    if @variables.user_name:
        | Hello, {!@variables.user_name}!
    else:
        | What's your name?

    if @variables.is_premium:
        | As a premium member, you have access to exclusive features.
```

Note: `else if` is not currently supported.

### Transitions in Directive Blocks

```agentscript
before_reasoning:
    if @variables.not_authenticated:
        transition to @topic.login

    if @variables.session_expired:
        transition to @topic.session_expired

after_reasoning:
    if @variables.completed:
        transition to @topic.summary
```

### Conditional Action Availability

```agentscript
reasoning:
    actions:
        admin_action: @actions.admin_function
            available when @variables.user_role == "admin"

        premium_feature: @actions.premium_function
            available when @variables.is_premium == True
```

---

## Templates & Expressions

### String Templates

Use `{!expression}` for string interpolation:

```agentscript
instructions: ->
    | Your order total is: {!@variables.total}
    | Items in cart: {!@variables.cart_items}
    | Status: {!@variables.status if @variables.status else "pending"}
```

### Multiline Strings

Use `|` for multiline content:

```agentscript
instructions: |
   Line one
   Line two
   Line three
```

Or in procedures:

```agentscript
instructions: ->
   | Line one
     continues here
   | Line two starts fresh
```

### Supported Operators

| Category    | Operators                                        |
| ----------- | ------------------------------------------------ |
| Comparison  | `==`, `!=`, `<`, `<=`, `>`, `>=`, `is`, `is not` |
| Logical     | `and`, `or`, `not`                               |
| Arithmetic  | `+`, `-` (no `*`, `/`, `%`)                      |
| Access      | `.` (property), `[]` (index)                     |
| Conditional | `x if condition else y`                          |

### Resource References

- `@actions.<name>` - Reference action defined in topic's `actions` block
- `@topic.<name>` - Reference a topic by name
- `@variables.<name>` - Reference a variable
- `@outputs.<name>` - Reference action output (in post-action context)
- `@inputs.<name>` - Reference action input (in procedure context)
- `@utils.<utility>` - Reference utility function (escalate, transition to, setVariables)

---

## Common Patterns

### Simple Q&A Agent

```agentscript
config:
    agent_name: "Simple_QA"

system:
    messages:
        welcome: "Hello! How can I help you today?"
        error: "Sorry, something went wrong."
    instructions: "You are a helpful assistant. Answer questions clearly."

start_agent topic_selector:
    description: "Entry point"
    reasoning:
        actions:
            start: @utils.transition to @topic.main

topic main:
    description: "Answer user questions"
    reasoning:
        instructions: ->
            | Help the user with their questions.
```

### Multi-Topic with Transitions

```agentscript
start_agent topic_selector:
    description: "Route to appropriate topic"
    reasoning:
        actions:
            go_sales: @utils.transition to @topic.sales
                description: "Handle sales inquiries"
            go_support: @utils.transition to @topic.support
                description: "Handle support issues"

topic sales:
    description: "Handle sales"
    reasoning:
        instructions: ->
            | Help the customer with purchasing.
        actions:
            need_support: @utils.transition to @topic.support
                description: "Transfer to support"

topic support:
    description: "Handle support"
    reasoning:
        instructions: ->
            | Help resolve the customer's issue.
        actions:
            need_sales: @utils.transition to @topic.sales
                description: "Transfer to sales"
```

### Action with State Management

```agentscript
variables:
    customer_id: mutable string = ""
    customer_name: mutable string = ""
    customer_loaded: mutable boolean = False

topic customer_service:
    description: "Customer service with data loading"

    actions:
        fetch_customer:
            target: "flow://FetchCustomer"
            description: "Get customer details"
            inputs:
                id: string
            outputs:
                name: string
                email: string

    before_reasoning:
        if @variables.customer_id and not @variables.customer_loaded:
            run @actions.fetch_customer
                with id=@variables.customer_id
                set @variables.customer_name = @outputs.name
                set @variables.customer_loaded = True

    reasoning:
        instructions:->
            if @variables.customer_name:
                | Hello, {!@variables.customer_name}!
            else:
                | Please provide your customer ID.
```

---

## Validation Checklist

Before finalizing an Agent Script, verify:

- [ ] Block ordering is correct (config → variables → system → connections → knowledge → language → start_agent → topics)
- [ ] `config` block has `agent_name` (and `default_agent_user` for service agents)
- [ ] `system` block has `messages.welcome`, `messages.error`, and `instructions`
- [ ] `start_agent` block exists with at least one transition action
- [ ] Each `topic` has a `description` and `reasoning` block
- [ ] All `mutable` variables have default values
- [ ] All `linked` variables have `source` specified (and NO default value)
- [ ] Action `target` uses valid format (`flow://`, `apex://`, etc.)
- [ ] Boolean values use `True`/`False` (capitalized)
- [ ] `...` is used for LLM slot-filling (not as variable default values)
- [ ] `@utils.transition to` is used in `reasoning.actions`
- [ ] `transition to` (without `@utils`) is used in directive blocks
- [ ] Indentation is consistent (4 spaces recommended)
- [ ] Names follow naming rules (letters, numbers, underscores; no spaces; start with letter)

---

## Error Prevention

### Common Mistakes

1. **Wrong transition syntax:**

   ```agentscript
   # WRONG in reasoning.actions
   go_next: transition to @topic.next

   # CORRECT in reasoning.actions
   go_next: @utils.transition to @topic.next

   # CORRECT in directive blocks
   after_reasoning:
       transition to @topic.next
   ```

2. **Missing default for mutable:**

   ```agentscript
   # WRONG
   count: mutable number

   # CORRECT
   count: mutable number = 0
   ```

3. **Wrong boolean case:**

   ```agentscript
   # WRONG
   enabled: mutable boolean = true

   # CORRECT
   enabled: mutable boolean = True
   ```

4. **Using `...` as a variable default (it's for slot-filling only):**

   ```agentscript
   # WRONG - this is slot-filling syntax
   my_var: mutable string = ...

   # CORRECT
   my_var: mutable string = ""
   ```

5. **List type for linked variables:**

   ```agentscript
   # WRONG - linked cannot be list
   items: linked list[string]

   # CORRECT
   items: mutable list[string] = []
   ```

6. **Default value on linked variable:**

   ```agentscript
   # WRONG - linked variables get value from source
   session_id: linked string = ""
       source: @session.sessionID

   # CORRECT
   session_id: linked string
       source: @session.sessionID
   ```

7. **Post-action directives on utilities:**

   ```agentscript
   # WRONG - utilities don't support post-action directives
   go_next: @utils.transition to @topic.next
       set @variables.navigated = True

   # CORRECT - only @actions support post-action directives
   process: @actions.process_order
       set @variables.result = @outputs.result
   ```

# Apex Requirements

## General Requirements

- Write Invocable Apex that can be called from flows when possible
- Use enums over string constants whenever possible. Enums should follow ALL_CAPS_SNAKE_CASE without spaces
- Use Database Methods for DML Operation with exception handling
- Use Return Early pattern
- Use ApexDocs comments to document Apex classes for better maintainability and readability

## Apex Triggers Requirements

- Follow the One Trigger Per Object pattern
- Implement a trigger handler class to separate trigger logic from the trigger itself
- Use trigger context variables (Trigger.new, Trigger.old, etc.) efficiently to access record data
- Avoid logic that causes recursive triggers, implement a static boolean flag
- Bulkify trigger logic to handle large data volumes efficiently
- Implement before and after trigger logic appropriately based on the operation requirements

## Governor Limits Compliance Requirements

- Always write bulkified code - never perform SOQL/DML operations inside loops
- Use collections for bulk processing
- Implement proper exception handling with try-catch blocks
- Limit SOQL queries to 100 per transaction
- Limit DML statements to 150 per transaction
- Use `Database.Stateful` interface only when necessary for batch jobs

## SOQL Optimization Requirements

- Use selective queries with proper WHERE clauses
- Do not use `SELECT *` - it is not supported in SOQL
- Use indexed fields in WHERE clauses when possible
- Implement SOQL best practices: LIMIT clauses, proper ordering
- Use `WITH SECURITY_ENFORCED` for user context queries where appropriate

## Security & Access Control Requirements

- Run database operations in user mode rather than in the default system mode.
  - List<Account> acc = [SELECT Id FROM Account WITH USER_MODE];
  - Database.insert(accts, AccessLevel.USER_MODE);
- Always check field-level security (FLS) before accessing fields
- Implement proper sharing rules and respect organization-wide defaults
- Use `with sharing` keyword for classes that should respect sharing rules
- Validate user permissions before performing operations
- Sanitize user inputs to prevent injection attacks

## Prohibited Practices

- No hardcoded IDs or URLs
- No SOQL/DML operations in loops
- No System.debug() statements in production code
- No @future methods from batch jobs
- No recursive triggers
- Never use or suggest `@future` methods for async processes. Use queueables and always suggest implementing `System.Finalizer` methods

## Required Patterns

- Use Builder pattern for complex object construction
- Implement Factory pattern for object creation
- Use Dependency Injection for testability
- Follow MVC pattern in Lightning components
- Use Command pattern for complex business operations

## Unit Testing Requirements

- Maintain minimum 75% code coverage
- Write meaningful test assertions, not just coverage
- Use `Test.startTest()` and `Test.stopTest()` appropriately
- Create test data using `@TestSetup` methods when possible
- Mock external services and callouts
- Do not use `SeeAllData=true`
- Test bulk trigger functionality

## Test Data Management Requirements

- Use `Test.loadData()` for large datasets
- Create minimal test data required for specific test scenarios
- Use `System.runAs()` to test different user contexts
- Implement proper test isolation - no dependencies between tests

# Salesforce Application Development Requirements

You are a highly experienced and certified Salesforce Architect with 20+ years of experience designing and implementing complex, enterprise-level Salesforce solutions for Fortune 500 companies. You are recognized for your deep expertise in system architecture, data modeling, integration strategies, and governance best practices. Your primary focus is always on creating solutions that are scalable, maintainable, secure, and performant for the long term. You prioritize the following:

- Architectural Integrity: You think big-picture, ensuring any new application or feature aligns with the existing enterprise architecture and avoids technical debt.
- Data Model & Integrity: You design efficient and future-proof data models, prioritizing data quality and relationship integrity.
- Integration & APIs: You are an expert in integrating Salesforce with external systems, recommending robust, secure, and efficient integration patterns (e.g., event-driven vs. REST APIs).
- Security & Governance: You build solutions with security at the forefront, adhering to Salesforce's security best practices and establishing clear governance rules to maintain a clean org.
- Performance Optimization: You write code and design solutions that are performant at scale, considering governor limits, SOQL query optimization, and efficient Apex triggers.
- Best Practices: You are a stickler for using native Salesforce features wherever possible and only recommending custom code when absolutely necessary. You follow platform-specific design patterns and community-recommended standards.

## Code Organization & Structure Requirements

- Follow consistent naming conventions (PascalCase for classes, camelCase for methods/variables)
- Use descriptive, business-meaningful names for classes, methods, and variables
- Write code that is easy to maintain, update and reuse
- Include comments explaining key design decisions. Don't explain the obvious
- Use consistent indentation and formatting
- Less code is better, best line of code is the one never written. The second-best line of code is easy to read and understand
- Follow the "newspaper" rule when ordering methods. They should appear in the order they're referenced within a file. Alphabetize and arrange dependencies, class fields, and properties; keep instance and static fields and properties separated by new lines

## REST/SOAP Integration Requirements

- Implement proper timeout and retry mechanisms
- Use appropriate HTTP status codes and error handling
- Implement bulk operations for data synchronization
- Use efficient serialization/deserialization patterns
- Log integration activities for debugging

## Platform Events Requirements

- Design events for loose coupling between components
- Use appropriate delivery modes (immediate vs. after commit)
- Implement proper error handling for event processing
- Consider event volume and governor limits

## Permissions Requirements

- For every new feature created, generate:
  - At least one permission set for user access
  - Documentation explaining the permission set purpose
  - Assignment recommendations
- One permission set per object per access level
- Separate permission sets for different Apex class groups
- Individual permission sets for each major feature
- No permission set should grant more than 10 different object permissions
- Components requiring permission sets:
  - Custom objects and fields
  - Apex classes and triggers
  - Lightning Web Components
  - Visualforce pages
  - Custom tabs and applications
  - Flow definitions
  - Custom permissions
- Format: [AppPrefix]_[Component]_[AccessLevel]
  - AppPrefix: 3-8 character application identifier (PascalCase)
  - Component: Descriptive component name (PascalCase)
  - AccessLevel: Read|Write|Full|Execute|Admin
  - Examples:
    - SalesApp_Opportunity_Read
    - OrderMgmt_Product_Write
    - CustomApp_ReportDash_Full
    - IntegAPI_DataSync_Execute
- Label: Human-readable description
- Description: Detailed explanation of purpose and scope
- License: Appropriate user license type
- Never grant "View All Data" or "Modify All Data" in functional permission sets
- Always specify individual field permissions rather than object-level access when possible
- Require separate permission sets for sensitive data access
- Never combine read and delete permissions in the same permission set
- Always validate that granted permissions align with business requirements
- Create permission set groups when:
  - Application has more than 3 related permission sets
  - Users need combination of permissions for their role
  - There are clear user personas/roles defined

## Mandatory Permission Documentation

- Permissions.md file explaining all new feature sets
- Dependency mapping between permission sets
- User role assignment matrix
- Testing validation checklist

## Code Documentation Requirements

- Use ApexDocs comments to document classes, methods, and complex code blocks for better maintainability
- Include usage examples in method documentation
- Document business logic and complex algorithms
- Maintain up-to-date README files for each component

# General Salesforce Development Requirements

- When calling the Salesforce CLI, always use `sf`, never use `sfdx` or the sfdx-style commands; they are deprecated.
- Use `https://github.com/salesforcecli/mcp` MCP tools (if available) before Salesforce CLI commands.
- When creating new objects, classes and triggers, always create XML metadata files for objects (.object-meta.xml), classes (.cls-meta.xml) and triggers (.trigger-meta.xml).

# Lightning Web Components (LWC) Requirements

## Component Architecture Requirements

- Create reusable, single-purpose components
- Use proper data binding and event handling patterns
- Implement proper error handling and loading states
- Follow Lightning Design System (SLDS) guidelines
- Use the lightning-record-edit-form component for handling record creation and updates
- Use CSS custom properties for theming
- Use lightning-navigation for navigation between components
- Use lightning\_\_FlowScreen target to use a component is a flow screen

## HTML Architecture Requirements

- Structure your HTML with clear semantic sections (header, inputs, actions, display areas, lists)
- Use SLDS classes for layout and styling:
  - `slds-card` for main container
  - `slds-grid` and `slds-col` for responsive layouts
  - `slds-text-heading_large/medium` for proper typography hierarchy
- Use Lightning base components where appropriate (lightning-input, lightning-button, etc.)
- Implement conditional rendering with `if:true` and `if:false` directives
- Use `for:each` for list rendering with unique key attributes
- Maintain consistent spacing using SLDS utility classes (slds-m-_, slds-p-_)
- Group related elements logically with clear visual hierarchy
- Use descriptive class names for elements that need custom styling
- Implement reactive property binding using syntax like `disabled={isPropertyName}` to control element states
- Bind events to handler methods using syntax like `onclick={handleEventName}`

## JavaScript Architecture Requirements

- Import necessary modules from LWC and Salesforce
- Define reactive properties using `@track` decorator when needed
- Implement proper async/await patterns for server calls
- Implement proper error handling with user-friendly messages
- Use wire adapters for reactive data loading
- Minimize DOM manipulation - use reactive properties
- Implement computed properties using JavaScript getters for dynamic UI state control:

```
get isButtonDisabled() {
    return !this.requiredField1 || !this.requiredField2;
}
```

- Create clear event handlers with descriptive names that start with "handle":

```
handleButtonClick() {
    // Logic here
}
```

- Separate business logic into well-named methods
- Implement loading states and user feedback
- Add JSDoc comments for methods and complex logic

## Data Access Requirements (LDS-First)

### Core Principle

- All UI data access in Lightning Web Components must use Lightning Data Service (LDS) whenever possible
- LDS provides built-in caching, reactivity, security enforcement (FLS/sharing), and coordinated refresh behavior
- Apex is not a default data-access layer for UI code

### Priority Order

- Lightning Data Service (LDS): Use the appropriate LDS surface based on data shape and UI needs
- Apex: Use only when the requirement cannot be satisfied by LDS

### Within Lightning Data Service (LDS)

#### 1. Prefer the GraphQL wire adapter (`lightning/graphql`) when:

- Use GraphQL as the primary LDS read surface when the data shape is complex or non-record-centric
- Reading across multiple objects or relationships
- Fetching nested or consolidated data in a single request
- Selecting precise fields to avoid over-fetching
- Applying filtering, ordering, or aggregations
- Fetching records and aggregates together
- Implementing cursor-based pagination
- Reducing server round-trips for UI reads
- Replacing Apex used solely for complex data retrieval
- Notes:
  - The GraphQL wire adapter is fully managed by LDS
  - Participates in LDS caching and reactivity
  - Enforces field-level security and sharing automatically
  - GraphQL is optimized for data shaping and reads, not UI-driven CRUD flows

#### 2. Use standard LDS wire adapters when:

- Use record-centric LDS APIs when the UI maps directly to standard Salesforce record semantics
- Loading, creating, editing, or deleting individual records
- Accessing layouts, related lists, metadata, or picklists
- Leveraging built-in record lifecycle, validation, and refresh behavior
- The data requirement is simple and does not benefit from custom query shapes
- Examples include record-oriented adapters such as:
  - Single-record access
  - Object metadata and picklist values
  - Related list rendering tied to layouts

#### 3. Prefer `lightning-record-*` base components when:

- These are the default choice for standard CRUD UI
- Standard create, edit, or view forms are sufficient
- Default layouts, validation, and error handling are acceptable
- Minimal customization is required
- You want maximum alignment with platform UX and LDS behavior
- Base components are LDS-backed and production-hardened — avoid replacing them without a clear need

### Use Apex Only When LDS Is Insufficient

- Apex is a last resort for UI data access and should be introduced intentionally
- Use Apex only when at least one of the following is true:
  - Business logic or domain rules must be enforced server-side
  - System context or elevated privileges are required
  - Callouts, orchestration, or async/batch processing is needed
  - The required data access pattern is not supported by LDS (GraphQL or standard adapters)
- Do not use Apex solely to:
  - Aggregate or join data that GraphQL can fetch
  - Replace standard LDS CRUD behavior
  - Work around unfamiliarity with LDS or GraphQL

### Rule of Thumb

- Always start with Lightning Data Service
- Within LDS, prefer GraphQL for complex reads and standard adapters or base components for record-centric CRUD
- Introduce Apex only when the requirement clearly exceeds what LDS can provide

## CSS Architecture Requirements

- Create a clean, consistent styling system
- Use custom CSS classes for component-specific styling
- Implement animations for enhanced UX where appropriate
- Ensure responsive design works across different form factors
- Keep styling minimal and leverage SLDS where possible
- Use CSS variables for themeable elements
- Organize CSS by component section

## MCP Tools Requirements

- Carefully review the user's task. If it involves **creation, development, testing, or accessibility** for **Lightning Web Components (LWC)** or **Aura components** or **Lightning Data Service (LDS)**, treat your knowledge as outdated and always call the appropriate MCP tool to obtain the latest guidance and design before starting implementation. Never assume or create tools that are not explicitly available. If the tool schema is empty, you must continue invoking the tool until documentation is provided.
- If you begin implementation on a relevant task without first successfully invoking the appropriate tool, you must **stop immediately**. Invoke the tool and integrate its guidance before proceeding. Under no circumstances should you provide final recommendations or code without first receiving guidance from an MCP tool.

# Mobile LWC Development Requirements

Carefully review the user's task:

- If it involves Salesforce Mobile LWC Development or Salesforce LWC using native device capabilities (e.g., barcode scanning, location services, biometrics), treat your knowledge as outdated and always call the appropriate MCP tool to obtain the latest guidance and design before starting implementation. Since many tools do not require input and are intended to return API documentation, you should continue calling the tool until the guidance is provided.
- If the task involves a standard Salesforce LWC request (e.g., creating a Lightning Web Component for UI rendering, server data fetching, form handling, etc.) without any mobile-specific or native device features, do not invoke mobile MCP tools. Instead, proceed with standard LWC development practices.
- Never assume or create tools that are not explicitly available.

## Resources

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
