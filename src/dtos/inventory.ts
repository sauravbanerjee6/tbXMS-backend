export interface addDeviceRequest {
    nodeLabel: string;
    locationId: number;
    deviceType: number;
    deviceModel: number;
    ipAddress: string;
}

export interface addDeviceResponse {
    responseCode: number;
    data: [];
    message: string;
}