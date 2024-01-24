load transient.mat
time = 1:size(u, 2);
t_step=10;
maxValues = max(u, [], 1);

plot(time/t_step, maxValues,'-','LineWidth',2);
hline=refline([0 150])
hline.Color='m'
hline.LineWidth=2
hline=refline([0 400])
hline.Color='y'
hline.LineWidth=2
xline=refline([0 1085])
xline.Color='r'
xline.LineWidth=2
xlim([0 30])
legend('core','XLPE degradation','XLPE mass loss','copper melting tmp')
xlabel('$\textrm{Time(s)}$','interpreter','latex');
ylabel('$\textrm{Core Temperature} (^{\circ}C)$','interpreter','latex');
title('\textrm{Core Temperature vs Time with short circuit current 17.6kA}','interpreter','latex');