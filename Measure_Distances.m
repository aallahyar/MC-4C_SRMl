clear all; close all; fclose all; clc
%% Get distances from .csv files
if ~exist('get_distances.m','file'),addpath('U:\Git_Rep\General\SMLM\get_distances');end
pth = 'D:\2016\05\24\getdists\';
d = dir([pth,'*.txt']);
edges = linspace(0,0.5,25); %24 bins
B=(edges(1:end-1)+edges(2:end))./2;
A1=B;h1={'Bin Centres'};
A2=B;h2={'Bin Centres'};
for ct = 1:length(d)
    n=fullfile(pth,d(ct).name);
    dat = dlmread(n,'\t',1,0); %skip first row
    xy=dat(:,4:5);
    [ dists ] = get_distances(xy,0.5); %all distances till 500nm
    N=histcounts(dists(:,1),edges);
    if ~isempty(regexp(d(ct).name,'WAPLKO'))
        A1(end+1,:)=N;h1{end+1}=d(ct).name;
    else
        A2(end+1,:)=N;h2{end+1}=d(ct).name;
    end
end
A1 = [h1;num2cell(A1')];
A2 = [h2;num2cell(A2')];
name = fullfile(pth,'result.xlsx');
xlswrite(name,A1,'WAPLKO');
xlswrite(name,A2,'WT');

%% Relative excess clustering in WAPL Knockout
WA = cell2mat(A1(2:end,1:8));
WT = cell2mat(A2(2:end,1:7));

WA_all = mean(WA(:,[2,3,4,5,6,8]),2); %skip dividing cell
WA_all = WA_all./WA_all(end);
WT_all = mean(WT(:,2:end),2);
WT_all = WT_all./WT_all(end);

Res = WA_all./WT_all;
xax=WT(:,1).*1E3;
bar(xax,Res)
xlim([0 500])
xlabel('r(nm)')
ylabel('relative abundance')