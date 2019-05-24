module TrafficLight where
import HDL.Hydra.Core.Lib
import HDL.Hydra.Circuits.Combinational

{- 
trafficLighta is Version 1 part
In this version, reset is only pressed once and for the rest, it is zero.
Sequence of state transitions:
Green for 3 clock cycles
Green -> Amber
Amber for 1 clock cycle
Amber -> Red
Red for 4 clock cycles
Red -> Amber
Amber for 1 clock cycles
Amber -> Green and then repeats
It has just one input (reset) and 3 possible outputs (Green, Amber, Red)
-}

trafficLighta :: CBit a =>a -> (a,a,a)
trafficLighta reset = (green,amber,red)
  where
    g1 = dff(or2 reset a2)
    g2 = dff(and2 reset' g1)
    g3 = dff(and2 reset' g2)
    a1 = dff(and2 reset' g3)
    r1 = dff(and2 reset' a1)
    r2 = dff(and2 reset' r1)
    r3 = dff(and2 reset' r2)
    r4 = dff(and2 reset' r3)
    a2 = dff(and2 reset' r4)
    reset' = inv reset
    green = or3 g1 g2 g3
    amber = or2 a1 a2
    red = or4 r1 r2 r3 r4


{- trafficLightb is Version 2 part
There are 2 inputs: walkrequest button and the reset button
There are 6 outputs: RED,AMBER,GREEN,WAIT,WALK,and WALKCOUNT
Sequence of state transitions:
Green when walkrequest is zero and pedestrian light is wait
when pedestrian presses walkrequest button:
Green -> Amber
Amber for 1 clock cycle
Amber -> Red
Red for 3 clock cycles if which the walk light is on and the pedestrian can walk for 3 clock cycles
Red -> Amber 
Amber for 1 clock cycle and wait light is on
Amber -> Green indicating pedestrians to wait and not cross the road and so on...
The walkCount counts the number of times the button walkrequest is pressed and it increments by one whenever walkrequest is pressed.
However, if the pedestrian presses the walkrequest button again and again, there would be no increment in the value of walkCount.
Hypothetically, if the reset button is pressed by the pedestrian, the walkCount drops to zero. 
-}
trafficLightb :: CBit a =>a -> a -> (a,a,a,a,a,[a])
trafficLightb reset walkrequest = (red,amber,green,wait,walk,c)
  where   
    green = dff(or3 reset amber2 (and2 walkrequest' green))
    amber1 = dff(and2 (and2 walkrequest green) green) 
    r1 = dff(and2 reset' amber1)
    r2 = dff(and2 reset' r1)
    r3 = dff(and2 reset' r2)
    amber2 = dff(and2 reset' r3)
    amber = or2 amber1 amber2
    red = or3 r1 r2 r3
    reset' = inv reset
    green' = inv green
    walkrequest' = inv walkrequest
    walk = red
    wait = or2 green amber
    c = mux1w reset (walkCount (and2 walkrequest (nor2 red amber))) (fanout 16 zero)
{-
This functions increments the value of walkCount whenever the walkrequest button is pressed.
-}
walkCount :: CBit a => a -> [a]
walkCount walkrequest = [x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15]
  where
    x0 = dff(mux1 walkrequest x0 y0)
    x1 = dff(mux1 walkrequest x1 y1)
    x2 = dff(mux1 walkrequest x2 y2) 
    x3 = dff(mux1 walkrequest x3 y3) 
    x4 = dff(mux1 walkrequest x4 y4)
    x5 = dff(mux1 walkrequest x5 y5)
    x6 = dff(mux1 walkrequest x6 y6) 
    x7 = dff(mux1 walkrequest x7 y7) 
    x8 = dff(mux1 walkrequest x8 y8)
    x9 = dff(mux1 walkrequest x9 y9)
    x10 = dff(mux1 walkrequest x10 y10) 
    x11 = dff(mux1 walkrequest x11 y11) 
    x12 = dff(mux1 walkrequest x12 y12)
    x13 = dff(mux1 walkrequest x13 y13)
    x14 = dff(mux1 walkrequest x14 y14) 
    x15 = dff(mux1 walkrequest x15 y15) 
    (c0,y0) = halfAdd x0 c1
    (c1,y1) = halfAdd x0 c2
    (c2,y2) = halfAdd x2 c3
    (c3,y3) = halfAdd x3 c4
    (c4,y4) = halfAdd x4 c5
    (c5,y5) = halfAdd x5 c6
    (c6,y6) = halfAdd x6 c7
    (c7,y7) = halfAdd x7 c8
    (c8,y8) = halfAdd x8 c9
    (c9,y9) = halfAdd x9 c10
    (c10,y10) = halfAdd x10 c11
    (c11,y11) = halfAdd x11 c12
    (c12,y12) = halfAdd x12 c13
    (c13,y13) = halfAdd x13 c14
    (c14,y14) = halfAdd x14 c15
    (c15,y15) = halfAdd x15 one

 



