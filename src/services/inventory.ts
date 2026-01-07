import { addDeviceRequest, addDeviceResponse } from "../dtos/inventory";
import { prisma } from "../util/prisma";

interface InventoryServices {
  createDevice(node: addDeviceRequest): Promise<addDeviceResponse>;
}

const inventoryServices: InventoryServices = {
  createDevice: async (node: addDeviceRequest): Promise<addDeviceResponse> => {
    try {
      const resultNodes = await prisma.nodes.create({
        data: {
          node_label: node.nodeLabel,
          location_id: node.locationId,
          device_type: node.deviceType,
          device_model: node.deviceModel,
          status: "unmonitored",
          monitoring_status: true,
        },
        select: {
          node_id: true,
        },
      });

      const nodeId = resultNodes.node_id;

      const resultInterfaces = await prisma.interfaces.create({
        data: {
          ip_address: node.ipAddress,
          node_id: nodeId,
          status: "unmonitored",
          monitoring_status: true,
        },
        select: {
          interface_id: true,
        },
      });

      const interfaceId = resultInterfaces.interface_id;

      const serviceIds = await prisma.services.findMany({
        where: {
          service_label: {
            in: ["ICMP", "SNMP", "HTTP"],
            mode: "insensitive",
          },
        },
        select: {
          service_id: true,
        },
      });

      console.log(serviceIds[0].service_id);

      const ifServiceData = serviceIds.map((s) => ({
        interface_id: interfaceId,
        service_id: s.service_id,
      }));

      const resultIfServices = await prisma.ifservices.createMany({
        data: ifServiceData,
        skipDuplicates: true,
      });
      return {
        responseCode: 200,
        message: "Device added successfully!",
        data: [],
      };
    } catch (error) {
      console.error("Error at createDevice Service: ", error);
      return { responseCode: 500, message: "Error Adding Device!", data: [] };
    }
  },
};

export { inventoryServices };
