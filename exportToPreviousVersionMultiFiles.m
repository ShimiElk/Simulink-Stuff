% looks for files to cenver to older version
reqVersion = "R2021a";
fname = "*"+".slx";
d = dir(fname);
fprintf("found %d elemnts\n", length({d.name}))

if isempty(length({d.name}))
    return
end

% converts the files to an older version

for k = 1 :length({d.name})
    exportToPreviousVersion(convertCharsToStrings (d(k).name),convertStringsToChars(reqVersion));
end
fprintf("Done\n")