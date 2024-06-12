

function events_pointpicker(ax, x::Observable, y::Observable; button = Mouse.left)
    on(events(ax).mouseposition) do pos
        mb = events(ax).mousebutton[]
        entered = is_mouseinside(ax) 
        if mb.button == button && mb.action == Mouse.press && entered
            pos = mouseposition(ax)
            xf = floor(Int, pos[1])
            yf = floor(Int, pos[2])
            x[] = xf == 0 ? xf = 1 : xf 
            y[] = yf == 0 ? yf = 1 : yf
        end
       
    end
end

function events_timeloop(ax, t::Observable)
    isrunning = Observable(false)
    on(events(ax).keyboardbutton) do event 
       if event.action == Keyboard.press && event.key == Keyboard.a
          isrunning[] = !isrunning[]
       end      
    end 

    on(events(ax).keyboardbutton) do event  
        println("isrunning: $isrunning")
        @async while isrunning[]
            # isopen(fig.scene) || break  # stop anim when we close control 
            t[] = t[] + 1
            prinln("$t")
            sleep(0.1) 
        end
    end 
end 






function events_scatterplot(ax,X,lon1,lat1)
    register_interaction!(ax, :my_interaction2) do event::MouseEvent, axis
        if event.type === MouseEventTypes.rightclick
            x2 = round(Int, event.data[1])
            y2 = round(Int, event.data[2])
            #  limits!(ax2, limits)        
            xs1 = to_value(X)[lon1.val, lat1.val, :]
            xs2 = to_value(X)[x2, y2, :]



            cor = Statistics.cor(xs1, xs2)
            figwww = Figure()
            axwww = Axis(figwww[1, 1])

            scatter!(axwww, xs1, xs2, markersize=5, color=:red)
            ablines!(axwww, 0, cor)
            tightlimits!(axwww)
            display(GLMakie.Screen(), figwww)
        end
    end

end