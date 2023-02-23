function cntr = findLongestContour (C)
  idx = 1;
  maxlen = 0;
  maxidx = 2;
  while (idx < size(C,2))
    len = C(2,idx);
    if (maxlen<len)
      maxlen = len;
      maxidx = idx + 1;
    end
    idx = idx + len + 1;
  end
  cntr = C(:,maxidx:maxidx+maxlen-1);
end