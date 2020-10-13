# TCP

## What is TCP?
- Deals with connection between devices
- Splits data into packets, then reassembles them at other end

![](https://miro.medium.com/max/3556/1*8BJFxJJCoQ0kc53gOHuEFg.png) 
- Going downwards is data being sent
    - Receives data from application and splits data into packets
- Going upwards is data being received
    - Receives packets from network and reassembles data to original data
    - acknowledgement sent to sender when received (provides error checking and correction)
        - Else: retransmitted 
