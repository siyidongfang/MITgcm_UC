

    %%% Calculate sea level gradient cross the slope
    Ymin_eta = Yshelfbreak-30*m1km;
    Ymax_eta = Yshelfbreak+30*m1km;
    yidx_shelf = round(Ymin_eta/dy):round((Ymin_eta+10*m1km)/dy);
    yidx_deep = round((Ymax_eta-10*m1km)/dy):round(Ymax_eta/dy);
    eta_shelf = mean(eta(xidx,yidx_shelf),'all');
    eta_deep  = mean(eta(xidx,yidx_deep),'all');
    deltaY = (Ymax_eta-10*m1km/2) - (Ymin_eta+10*m1km/2);
    detady(n) = (eta_shelf-eta_deep)/deltaY*100*m1km; %%% Unit: m/(100km)