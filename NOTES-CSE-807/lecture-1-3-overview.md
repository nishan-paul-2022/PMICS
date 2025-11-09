Based on the excerpts provided from the file "Lecture-1-3-Information-and-Cybersecurity.pdf," below is a comprehensive indexing of the main topics and key concepts covered in the material.

### **CSE 807 - INFORMATION & CYBER SECURITY**

---

### I. Critical Infrastructure (Pages 3-9)
*   **Critical Information Infrastructure (CII)**
    *   Examples of CII (e.g., Janata Bank Limited, Rupali Bank Limited, Ruppur Nuclear Power Plant Establishment Project, Biman Bangladesh Airlines, BRTA, Land Records, Police Headquarters, RAB)
    *   Elements of CII
        *   Physical
        *   Cyber
        *   Human
    *   IT Infrastructure
    *   Component of IT infrastructure
*   **Digital Transformation**
*   **Laws, Legislations, Acts, Guidelines**
    *   ISO/IEC 27001 — Information Security Management System
    *   ISO/IEC 27035 — Information Security Incident Management
    *   ISO/IEC 27032:2023 — Cybersecurity — Guidelines for Internet security
    *   Legal Focus Areas (Data Protection, Fraud Prevention, Online Harassment and Stalking, Contracts and Employment Law, Reduce or prevent cybercrime)

### II. Core Concepts: Assets and Information Systems (Pages 10-21)
*   **Asset and Value**
    *   Defining an Asset (Anything of value owned by an organization, tangible/intangible)
    *   The Most Valuable Asset: Information
    *   The Most Vulnerable Asset: Information
    *   Information Definition (Organized, structured, and meaningful data)
*   **Information as Valuable and Vulnerable**
    *   ICT as the major resource fueling business ideas and innovations in the 21st century.
    *   Increased dependence on automated systems invites ICT risks and threats.
    *   Information is treated as the most valuable and vulnerable asset.
*   **Security Concerns**
    *   Safety of the Asset
    *   Security of the Information (The Most Important Concern of the World)
*   **Information Systems (IS)**
    *   Definition (Coordinated arrangement of people, data, processes, and technology for managing information)
    *   Components of Information Systems
        *   Data
        *   Software Hardware
        *   People
        *   Procedures

### III. Information Security and the CIA Triad (Pages 22-60)
*   **Information Security Fundamentals**
    *   Information Security is crucial for business continuity (BC), minimizing business risk (BR), maximizing ROI, and gaining competitive edge.
    *   Information Security Objectives
    *   Information Security Definition (Practice of preventing unauthorized access, use, disclosure, disruption, modification, inspection, recording or destruction of information—physical or electronic).
*   **The Information Security Triad (CIA)**
    *   **Availability**
        *   Definition (Protection from disruptions in access; reliable).
        *   Maintenance Methods
            *   Mitigating Denial of Service (DoS) using firewalls.
            *   Mitigating power outages using redundant power and generators.
            *   Mitigating hardware failures using redundant components.
            *   Mitigating destruction using backups.
    *   **Confidentiality**
        *   Definition (Protection from unauthorized access; limit).
        *   Characteristic of data not made available or disclosed to unauthorized persons.
        *   Protection of sensitive information from unauthorized access or disclosure.
        *   Relates to permitting authorized access while protecting from improper disclosure.
        *   Data requiring protection (PII or PHI).
        *   Personally Identifiable Information (PII).
        *   Protected Health Information (PHI).
        *   Concept of Sensitivity (Measure of importance assigned to information).
    *   **Integrity**
        *   Definition (Protection from unauthorized modification; trustworthy and accurate).
        *   Violation of integrity (Significant as it may lead to attacks against availability or confidentiality).
        *   Control and Verification Methods (Version control, checksums/cryptographic checksums, verified by logging, digital signatures, hashes, encryption, access controls).
        *   Impact of Loss of Integrity (Fraud, Inaccuracy, Erroneous decisions, Failure of hardware, Loss of compliance).
        *   Consistency (Data instances identical in form, content, meaning).
        *   Integrity vs Consistency (Integrity: data is correct; Consistency: data format is correct/correct relative to other data).

### IV. Cybersecurity vs. Information Security (Pages 61-66)
*   **Distinction**
    *   Cybersecurity is a part of Information Security.
    *   Cybersecurity definition (Protection of information assets by addressing threats to information processed, stored and transported by **internetworked** information systems).
    *   Information Security definition (Protection of information and information systems to provide CIA).
    *   Cybersecurity excludes natural hazards, personal mistakes, or physical security.
    *   Relationship among security domains described in ISO 27032.

### V. Security Principles and Controls (Pages 67-106)
*   **Identification** (Claim of identity)
*   **Authentication** (Verification/proving identity)
*   **Non-repudiation** (Signed contracts, Digital signatures, Video surveillance)
*   **AAA (Authentication, Authorization, Accounting)**
*   **Cyber Security Domains**
*   **Cyber Security Layers** (Defense in depth)
    *   Application Security (Protecting software/devices by identifying, fixing, and preventing vulnerabilities).
*   **Cyber Kill Chain**
*   **Cyber Security Controls – Common Categories with Examples**

### VI. Asset Management and Data Handling (Pages 107-147)
*   **Asset Lifecycle**
    *   Five classic stages: Planning, Acquisition, Utilization, Maintenance, Disposal.
    *   Asset Lifecycle Calculation (Straight-line method for depreciation).
*   **IT Asset Management**
    *   Inventory (Making a registry of all information assets, including Hardware, Software, and Information Assets).
    *   Classification (Locating, identifying owners/users/custodians, recognizing organizational impacts of security compromises related to CIA).
        *   Classification Examples (Highly restricted, Moderately restricted, Low sensitivity/internal use only, Unrestricted public data).
    *   Labeling (Assigning security markings based on sensitivity level).
    *   Retention
    *   Destruction
*   **Data Management**
    *   Data Management Stages (Collection, Entry, Access/Usage/Process, Transfer, Storing, Deletion).
    *   Data States (Data at Rest, Data in Transit, Data in Use).
    *   Data Remanence (Data left on media after deleting).
    *   Data Retention and Auditability.
*   **Data Classification**
    *   Considerable Items (16 questions covering security requirements, life cycle, ownership, and access rights).
    *   Process
    *   Post-Classification (Establishing security controls like encryption, authentication, logging).
    *   Military Classification (Top Secret, Secret).
    *   Non-Military Sample (Restricted, Confidential, Internal, Public information).
*   **Security Threats to Data**
    *   Covert Shortage Channel (Conveys information via writing data to a common storage area).
    *   Data diddling (Small, incremental changes to data during storage/processing, often by insiders).

### VII. Information Security Models (Pages 148-163)
*   **Overview of Models** (Bell-LaPadula, Biba, Clark-Wilson, TCSEC, Brewer and Nash Model, Goguen–Meseguer Model, Sutherland Model, Graham–Denning Model, Harrison–Ruzzo–Ullman Model).
*   **Bell-LaPadula**
    *   Focus: Confidentiality.
    *   Main rules: Simple security rule (cannot read higher level data), *-property (star property) rule, and strong star property rule.
*   **Biba Model**
    *   Focus: Integrity (Reversed version of Bell-LaPadula).
    *   Uses Integrity labels/levels.
    *   Objectives: Prevent unauthorized modification, prevent modification by unauthorized subjects, protect internal/external object consistency.