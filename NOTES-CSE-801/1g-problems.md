# Computer Networking: Comprehensive Problem Solutions - Part 7

Welcome to Part 7 of the comprehensive guide for Computer Networking problems. This document contains detailed, step-by-step solutions for problems P32 through P34, covering fundamental concepts in message segmentation, optimal segment size, and Skype phone call technology.

## Table of Contents

- [P32: Message Segmentation](#p32-message-segmentation)
- [P33: Optimal Segment Size](#p33-optimal-segment-size)
- [P34: Skype Phone Call](#p34-skype-phone-call)

---

## P32: Message Segmentation

**Problem:** Experiment with the Message Segmentation interactive animation at the book's Web site. Do the delays in the interactive animation correspond to the delays in the previous problem? How do link propagation delays affect the overall end-to-end delay for packet switching (with message segmentation) and for message switching?

### Solution Steps

**Step 1: Understanding Message vs Packet Switching**
The problem refers to an interactive animation comparing message switching and packet switching. In message switching, entire messages are stored and forwarded as units. In packet switching, messages are broken into smaller packets that travel independently.

**Step 2: The Experiment Setup**
The animation likely shows data transmission over multiple links with propagation delays. The question asks how the animation's delays compare to previous problems and how propagation delays affect the two switching methods.

**Step 3: Message Switching Characteristics**
**Message Switching:**

- Entire message stored at each intermediate node
- Message waits for complete reception before forwarding
- Higher delay due to store-and-forward of large messages
- More buffering required at switches

**Packet Switching:**

- Message divided into small packets
- Each packet forwarded independently
- Pipelining effect reduces overall delay
- More efficient for large messages

**Step 4: Propagation Delay Impact**
**In Message Switching:**

- Propagation delay affects the entire message
- Long messages experience full propagation delay on each link
- Total delay increases significantly with message size

**In Packet Switching:**

- Only packet propagation delay matters
- Pipelining allows overlapping transmission
- Propagation delay impact is reduced

**Step 5: Comparison with Previous Problems**
This relates to problems like P10 (end-to-end delay) and P11 (cut-through switching). The animation likely demonstrates that packet switching with segmentation reduces the impact of propagation delays compared to message switching.

**Step 6: Key Insights**

**Delay Components:**

- **Transmission delay:** Time to send data onto link
- **Propagation delay:** Time for signal to travel
- **Processing delay:** Time for node to process

**Message Switching Drawbacks:**

- High delay for large messages
- High buffering requirements
- Not suitable for interactive traffic

**Packet Switching Advantages:**

- Better delay characteristics
- More efficient resource usage
- Better for real-time applications

**Step 7: Real-World Implications**

- Modern networks use packet switching
- Segmentation allows better delay control
- Understanding these trade-offs is crucial for network design

The animation demonstrates why packet switching replaced message switching in modern networks.

---

## P33: Optimal Segment Size

**Problem:** Consider sending a large file of F bits from Host A to Host B. There are three links (and two switches) between A and B, and the links are uncongested (that is, no queuing delays). Host A segments the file into segments of S bits each and adds 80 bits of header to each segment, forming packets of L = 80 + S bits. Each link has a transmission rate of R bps. Find the value of S that minimizes the delay of moving the file from Host A to Host B. Disregard propagation delay.

### Solution Steps

**Step 1: Understanding Message Segmentation**
The problem involves sending a large file F bits from Host A to Host B over three links. Host A segments the file into packets of S bits each, adding 80 bits of header to each packet. The goal is to find the optimal segment size S that minimizes the total delay.

**Step 2: Delay Components**
For each packet:

- **Transmission delay:** (S + 80)/R per link
- **Propagation delay:** d_i/s_i per link (ignored as per problem)
- **Processing delay:** d_proc per switch (ignored)

Since propagation and processing delays are ignored, only transmission delays matter.

**Step 3: Total Delay Analysis**
The file has F bits, divided into packets of S bits each.

**Number of packets:** F/S (rounded up, but for large F we approximate)

**Time for first packet:** 3 × (S + 80)/R (transmission through 3 links)

**Subsequent packets:** Each additional packet adds (S + 80)/R to the total time (since they can start transmitting while previous packets are in transit).

**Total time ≈ 3 × (S + 80)/R + (F/S - 1) × (S + 80)/R**

**Simplified:** Total delay = (S + 80)/R × (3 + F/S - 1) = (S + 80)/R × (F/S + 2)

**Step 4: Optimizing Segment Size**
To minimize delay with respect to S:

**Delay = (S + 80)/R × (F/S + 2)**

Let H = 80 (header size), R = transmission rate

**Delay = (S + H)/R × (F/S + 2)**

Take derivative with respect to S and set to zero:

**d/dS [(S + H)(F/S + 2)] = 0**

**Derivative:** (F/S + 2) + (S + H) × (-F/S²) = 0

**F/S + 2 - (S + H)F/S² = 0**

**Multiply by S²:** F S + 2 S² - (S + H) F = 0

**2 S² + F S - H F = 0**

**Solve quadratic:** S = [-F ± √(F² + 8 H F)] / 4

**S = [-F + √(F(F + 640))] / 4**

For large F: **S ≈ √(40 × F)**

**Step 5: Key Insights**

**Trade-offs in Segmentation:**

- **Small packets:** Lower queuing delay, but more headers reduce efficiency
- **Large packets:** Fewer headers, but higher delay for each packet
- **Optimal size:** Balances header overhead with transmission efficiency

**Real-World Application:**

- TCP uses similar calculations for Maximum Segment Size (MSS)
- Network protocols optimize packet sizes for different link characteristics
- Understanding this optimization is key to protocol design

This problem demonstrates the mathematical optimization underlying network protocol design.

---

## P34: Skype Phone Call

**Problem:** Skype offers a service that allows you to make a phone call from a PC to an ordinary phone. This means that the voice call must pass through both the Internet and through a telephone network. Discuss how this might be done.

### Solution Steps

**Step 1: Understanding Skype's PC-to-Phone Service**
Skype offers a service that allows users to call traditional telephone numbers from a computer. This bridges the gap between internet-based VoIP (Voice over IP) systems and the traditional Public Switched Telephone Network (PSTN).

**Step 2: The Communication Path**
A Skype call from a PC to a regular phone follows this path:

**PC → Internet → Skype Gateway → PSTN → Destination Phone**

**Step 3: Detailed Path Explanation**

**1. PC to Internet:**

- User speaks into computer microphone
- Skype software digitizes the audio
- Audio encoded using Skype's proprietary codec
- Data sent as IP packets over internet connection

**2. Internet Transmission:**

- Packets routed through internet using standard IP protocols
- May traverse multiple networks and routers
- Quality depends on internet connection and congestion

**3. Skype Gateway:**

- Skype maintains special servers that interface between internet and telephone networks
- Gateway receives VoIP packets from internet
- Converts digital audio back to analog telephone signal
- Connects to PSTN using standard telephone protocols

**4. Public Switched Telephone Network (PSTN):**

- Traditional telephone network
- Uses circuit-switched technology
- Routes call to destination telephone
- Maintains call quality standards

**5. Destination Phone:**

- Receives call through normal telephone infrastructure
- User hears the caller's voice

**Step 4: Technical Challenges**

**Protocol Conversion:**

- VoIP uses packet switching (internet protocols)
- PSTN uses circuit switching (telephone protocols)
- Gateway must handle this conversion seamlessly

**Quality of Service:**

- Internet can have variable delay and loss
- PSTN expects consistent quality
- Skype must manage jitter and packet loss

**Signaling:**

- Skype uses proprietary signaling
- Must interface with telephone signaling systems (SS7)

**Step 5: How It Works in Practice**

**Call Setup:**

1. User dials phone number in Skype application
2. Skype routes call to appropriate gateway server
3. Gateway signals PSTN to establish connection
4. Once connected, audio flows PC → Internet → Gateway → PSTN → Phone

**Audio Processing:**

- PC captures audio and sends in real-time
- Internet introduces some delay and potential quality issues
- Gateway smooths out variations
- PSTN delivers consistent quality to destination

**Step 6: Key Technologies Involved**

**VoIP Protocols:**

- RTP (Real-time Transport Protocol) for audio
- Proprietary Skype codecs for compression

**Gateway Technologies:**

- Media Gateway Control Protocol (MGCP)
- Session Initiation Protocol (SIP)
- H.323 for multimedia communication

**Telephone Network Integration:**

- SS7 signaling for call setup
- TDM (Time Division Multiplexing) for audio transport

**Step 7: Business and Technical Implications**

**Why This Service Exists:**

- Bridges old and new telephone technologies
- Allows internet users to call anyone with a phone
- Creates new revenue streams for VoIP providers

**Technical Complexity:**

- Requires maintaining gateway infrastructure
- Must handle international calling
- Quality control across heterogeneous networks

**Step 8: Modern Evolution**
Today, similar services exist from multiple providers (Vonage, Google Voice, etc.), all using similar gateway architectures to connect internet calls to traditional telephone networks.

This service demonstrates how modern internet technologies can seamlessly integrate with legacy telephone infrastructure.

---

## Conclusion

You've completed Part 7 and the entire comprehensive guide for Computer Networking problems. These solutions cover fundamental concepts in message segmentation experiments, optimal segment size calculations, and Skype's PC-to-phone calling technology. The complete series spans 34 problems across 7 parts, providing thorough coverage of computer networking principles.
