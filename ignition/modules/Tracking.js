const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("TrackingModule", (m) => {
  const initialShipmentCount = m.getParameter("initialShipmentCount", 0);

  const tracking = m.contract("Tracking", [], {
    gasLimit: 3000000,
  });

  return { tracking };
});
