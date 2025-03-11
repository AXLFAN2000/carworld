pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function _init()
    plr={
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
    controller(plr)
    if fget(mget(flr((plr.x+4)/8),flr((plr.y+4)/8)),1)==true   then
        plr.speed=1.2
    else
        plr.speed=1
    end
    if fget(mget(flr((plr.x+4)/8),flr((plr.y+4)/8)),0)==true and plr.gas<100 then
        plr.gas+=10
        sfx(2)
    end
    if plr.gas>100 then
        plr.gas=100
    end
end

function _draw()
    cls(3)
    map(0)
    draw_health()
    spr(plr.sp,plr.x,plr.y,1,1,plr.fx,plr.fy)
    print("carworld",1,1,6)
    print("will you stay on the road",0,110,6)
    print("or blaze your own trail")
    print(flr(plr.gas), 115,10,0)
end

--new functions below



function controller(plr) -- player movement
    if btn(5) then
        sfx(1)
    end
    local lx=plr.x -- last x pos
    local ly=plr.y -- last y pos 
    
    if btn(1) or btn(2) or btn(3) or btn(0) then
        if btn(1) then --right
            plr.x+=plr.speed*plr.velocity/2
            plr.fx=false
            plr.fy=false
            plr.sp=1
            plr.driving=true
            plr.lastdir=1
            if collide(plr) then
                plr.x=lx
            end
        end
        if btn(0) then --left
            plr.x-=plr.speed*plr.velocity/2
            plr.fx=true
            plr.fy=false
            plr.sp=1
            plr.driving=true
            plr.lastdir=0
            if collide(plr) then
                plr.x=lx
            end
        end
        if btn(2) then --up
            plr.y-=plr.speed*plr.velocity/2
            plr.sp=2
            plr.fy=false
            plr.driving=true
            plr.lastdir=2
            if collide(plr) then
                plr.y=ly
            end
        end
        if btn(3) then --down
            plr.y+=plr.speed*plr.velocity/2
            plr.sp=2
            plr.fy=true
            plr.driving=true
            plr.lastdir=3
            if collide(plr) then
                plr.y=ly
            end
        end
    else 
        plr.driving=false
        if plr.lastdir==1 and plr.velocity>0 then
            plr.x+=1*plr.velocity/2
        elseif plr.lastdir==0 and plr.velocity>0 then
            plr.x-=1*plr.velocity/2
        elseif plr.lastdir==2 and plr.velocity>0 then
            plr.y-=1*plr.velocity/2
        elseif plr.lastdir==3 and plr.velocity>0 then
            plr.y+=1*plr.velocity/2
        end
        if collide(plr) then
            plr.x=lx
            plr.y=ly
        end
    end
    if plr.driving==true and plr.velocity<4 then
        plr.velocity+=.5
    elseif plr.driving==false and plr.velocity>0 then
        plr.velocity-=.3
    end
    if plr.x<0 then
        plr.x=lx
    elseif plr.y<0 then
        plr.y=ly
    end
end

function vrooming()
    if vcd>0 then
        vcd-=5
    end
    if vcd==0 then
        vroom=true
    end
    if vroom==true and plr.driving==true then
        sfx(0)
        vroom=false
        vcd=30
    end
end

function collide(plr)
    collision={
        x1=0,
        x2=0,
        y1=0,
        y2=0
    }
        collision.x1=(plr.x+1)/8
        collision.y1=(plr.y+1)/8
        collision.x2=(plr.x+6)/8
        collision.y2=(plr.y+7)/8

        local A=fget(mget(collision.x1,collision.y1),2)
        local B=fget(mget(collision.x1,collision.y2),2)
        local C=fget(mget(collision.x2,collision.y2),2)
        local D=fget(mget(collision.x2,collision.y1),2)
    if A or B or C or D then
    return true
    else
    return false
    end
end

function update_health()
    if plr.driving==true then
        plr.gas-=.1
    end
    bar.gas=41*plr.gas/100
end

function draw_health()
    rect(80,2,125,8,5)
    rectfill(82,4,82+bar.gas,6,0)
end