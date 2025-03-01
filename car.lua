pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function _init()
    p={
        sp=1,
        x=63,
        y=63,
        fx=false,
        fy=false,
        speed=1,
        gas=100,
        driving=false,
        velocity=0,
        lastdir=0
    }
    bar={
        gas=100
    }
    vroom=true
    vcd=30
end
 
function _update()
    update_health()
    vrooming()
    controller()
    if fget(mget(flr((p.x+10)/8),flr((p.y+4)/8)),1)==true   then
        p.speed=1.2
    else
        p.speed=1
    end
    if fget(mget(flr((p.x+10)/8),flr((p.y+4)/8)),0)==true and p.gas<100 then
        p.gas+=10
    end
    if p.gas>100 then
        p.gas=100
    end
end

function _draw()
    cls(3)
    draw_health()
    map(1)
    spr(p.sp,p.x,p.y,1,1,p.fx,p.fy)
    print("carworld",1,1,6)
    print("will you stay on the road",0,110,6)
    print("or blaze your own trail")
    print(flr(p.gas), 115,10,0)
end

--new functions below



function controller()
    if btn(5) then
        sfx(1)
    end
    if btn(1) or btn(2) or btn(3) or btn(0) then
        if btn(1) then --right
            p.x+=p.speed*p.velocity/2
            p.fx=false
            p.fy=false
            p.sp=1
            p.driving=true
            p.lastdir=1
        end
        if btn(0) then --left
            p.x-=p.speed*p.velocity/2
            p.fx=true
            p.fy=false
            p.sp=1
            p.driving=true
            p.lastdir=0
        end
        if btn(2) then --up
            p.y-=p.speed*p.velocity/2
            p.sp=2
            p.fy=false
            p.driving=true
            p.lastdir=2
        end
        if btn(3) then --down
            p.y+=p.speed*p.velocity/2
            p.sp=2
            p.fy=true
            p.driving=true
            p.lastdir=3
        end
    else 
        p.driving=false
        if p.lastdir==1 and p.velocity>0 then
            p.x+=1*p.velocity/2
        elseif p.lastdir==0 and p.velocity>0 then
            p.x-=1*p.velocity/2
        elseif p.lastdir==2 and p.velocity>0 then
            p.y-=1*p.velocity/2
        elseif p.lastdir==3 and p.velocity>0 then
            p.y+=1*p.velocity/2
        end
    end
    if p.driving==true and p.velocity<4 then
        p.velocity+=.5
    elseif p.driving==false and p.velocity>0 then
        p.velocity-=.3
    end
end

function vrooming()
    if vcd>0 then
        vcd-=5
    end
    if vcd==0 then
        vroom=true
    end
    if vroom==true and p.driving==true then
        sfx(0)
        vroom=false
        vcd=30
    end
end


function update_health()
    if p.driving==true then
        p.gas-=.1
    end
    bar.gas=41*p.gas/100
end

function draw_health()
    rect(80,2,125,8,5)
    rectfill(82,4,82+bar.gas,6,0)
end