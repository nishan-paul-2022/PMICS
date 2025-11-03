# CSE-804 | Network and Internet Security

This path starts with the basics, moves to identifying threats, then covers how to defend against them, and finally, how to manage and design secure networks.

## **Part 1: The Foundation - How Networks Work**

First, let's understand the playground. Before you can defend a network, you need to know what it is and how it's built.

*   **1. Internet Architecture:** Learn the basic structure of the internet.
*   **2. Network security at different layers of the OSI and TCP/IP models:** Understand the different "layers" of network communication. Think of this as the different departments in a company, each with a specific job.

## **Part 2: The Problems - What Are the Dangers?**

Now that you know how networks work, let's look at the common problems and vulnerabilities.

*   **3. Security flaws on the Internet:** Get a general overview of the weak spots on the internet.
*   **4. Viruses and worms:** Learn about malicious software that can infect and spread through networks.
*   **5. Common Attacks on Networks:**
    *   **Denial of Service (DoS) & Distributed Denial of Service (DDoS) attacks:** Overwhelming a system with so much traffic that it crashes.
    *   **Reflection & Amplification attacks:** Clever ways attackers multiply their power to launch massive DDoS attacks.
    *   **DNS (Domain Name System) hijacking:** When an attacker secretly redirects you to a fake website.
    *   **Routing attacks:** When an attacker messes with the "GPS" of the internet, sending data to the wrong places.

## **Part 3: The Defenses - How to Protect the Network**

Here we'll cover the tools and strategies used to protect against the attacks we just learned about.

*   **6. Firewalls:** The first line of defense. A digital wall that blocks unwanted traffic.
*   **7. Security Protocols (The Rules of Safe Communication):**
    *   **SSL (Secure Sockets Layer):** The original technology that makes websites secure (you see it as `https` in your browser).
    *   **IPsec (Internet Protocol Security):** A powerful set of rules to secure communication directly between two computers.
    *   **Kerberos:** A system used inside big organizations to make sure users are who they say they are.
*   **8. Securing Specific Services:**
    *   **Email security:** Protecting against spam, phishing, and other email-based threats.
    *   **VoIP (Voice over Internet Protocol) security:** Securing phone calls made over the internet.
*   **9. Wireless Security:**
    *   **Wireless infrastructure security:** How to protect Wi-Fi networks.
    *   **WEP (Wired Equivalent Privacy) cracking:** Learning how older, insecure Wi-Fi was broken, to understand why modern security is better.

## **Part 4: The Watchtower - Detecting and Responding to Attacks**

Even with good defenses, attackers might get through. This part is about how to spot them and what to do next.

*   **10. Network Intrusion Detection and Analysis:**
    *   **NIDS (Network Intrusion Detection System):** A "burglar alarm" for your network that alerts you to suspicious activity.
    *   **NIPS (Network Intrusion Prevention System):** A more advanced alarm that not only detects but also tries to stop the attack automatically.
    *   **Snort rules and alerts:** Learning to use a popular NIDS/NIPS tool to create custom detection rules.
    *   **NIDS/NIPS evidence acquisition:** How to collect proof of an attack for analysis.

## **Part 5: Advanced Topics - Designing and Managing Secure Systems**

This is where everything comes together. You'll learn how to design secure systems from the ground up and manage them for a business.

*   **11. Designing Enterprise systems for Access Control, Authentication, and Auditing (AAA):**
    *   **Access Control:** Who is allowed to do what?
    *   **Authentication:** How do you prove you are who you say you are? (e.g., passwords, biometrics).
    *   **Auditing:** Keeping a log of who did what and when.
*   **12. Supporting Secondary Network Connectivity:** How to securely connect different types of devices and networks:
    *   **Wireless**
    *   **VPNs (Virtual Private Networks):** A secure tunnel over the internet.
    *   **BYOD (Bring Your Own Device):** How to safely let employees use their personal phones and laptops for work.
*   **13. Building for Failure (Resiliency):**
    *   **Resiliency Management, Business Continuity, Disaster Recovery:** Planning for the worst. What happens if a server fails or a natural disaster strikes? How do you keep the business running?
*   **14. Incident Response:**
    *   **Methods to prevent, detect and respond to security breaches:** Creating a formal plan for what to do when a security incident happens.
    *   **The role of Incident Response Teams:** The "firefighters" who are called in to handle a security breach.

By following this path, a beginner can build a solid understanding, starting from the basics and gradually moving to more complex, real-world applications of network security.