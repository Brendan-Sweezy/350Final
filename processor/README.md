
# Processor
## NAME (NETID)
Brendan Sweezy (bs299)

## Description of Design
I designed my processor as a 5 stage pipelined processor (Fetch, Decode, Execute, Memory, Write). For every intersection of pipeline stages, I created registers to store essential values (instruction, PC, result, etc.). Each stage progresses on to the next by updating the succeeding register on the negative clock edge. For every pipeline stage I also implemented a control module that deals with all control related to that stage, and any interactions with other stages (dependencies, etc.).

## Bypassing
There are many bypasses implemented into my CPU to avoid the necessity of stalling as much as possible. In general, I handle bypassing in the decoding stage of my processor. If the decoding stage needs a register value that is being modified by the execute or memory stage, then that value is fed back instead of the register it is meant to read from. There are many special cases that require more logic (jr, $0, etc.), but they all are taken into consideration in my processor. 

## Stalling
For stalling, on any instructions that could cause a dependency that cannot be solved by bypassing (lw -> bne, lw -> add), I pause the progression of PC, and stop all pipeline stages before execute from progressing by freezing the registers before by not writing new values, and writing a nop in-between the decency. From there any dependency can be solved by my bypassing logic.

## Optimizations
My stall logic is not perfectly optimized. For any dependency that could require a stall (i.e. a branch after a load word), my processor automatically assumes a dependency and inserts a stall, so by checking for dependencies, I could make my CPU more efficient. I also freeze all stages on multiplication or division calls, and the instructions before mult/div could continue through the CPU to make the CPU faster.

## Bugs
There are no current bugs known for my CPU, as it can execute every program I have tested on it.