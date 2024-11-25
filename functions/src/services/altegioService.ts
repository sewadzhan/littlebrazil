import axios from "axios";
import { ALTEGIO_API_URL, ALTEGIO_PARTNER_TOKEN, ALTEGIO_USER_TOKEN } from "../config";
import { Service } from "../interfaces/service";
import { Client } from "../interfaces/client";

// Get companies
export const getCompaniesFromAltegio = async () => {
  const url = `${ALTEGIO_API_URL}/companies`;
  try {
    const response = await axios.get(url, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      },
    });
    return response.data;
  } catch {
    throw new Error("Error fetching companies from Altegio");
  }
};

// Get a company
export const getCompanyFromAltegio = async (id: string) => {
  const url = `${ALTEGIO_API_URL}/company/${id}`;
  try {
    const response = await axios.get(url, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      },
    });
    return response.data;
  } catch {
    throw new Error("Error getting a company from Altegio");
  }
};

// Get clients
export const getClientsFromAltegio = async (companyId: string) => {
  const url = `${ALTEGIO_API_URL}/company/${companyId}/clients`;
  try {
    const response = await axios.get(url, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      },
    });
    return response.data;
  } catch {
    throw new Error("Error fetching clients from Altegio");
  }
};

// Add a client
export const addClientToAltegio = async (companyId: string, name: string, phone: string, surname: string, sexId: number, birthDate?: string) => {
  const url = `${ALTEGIO_API_URL}/clients/${companyId}`;
  try {
    const response = await axios.post(url, {
      name,
      phone,
      surname,
      'birth_date': birthDate,
      'sex_id': sexId,
    }, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      }
    });
    return response.data;
  } catch (error) {
    throw new Error("Error adding client from Altegio: " + error);
  }
};

// Get a client
export const getClientFromAltegio = async (companyId: string, id: string) => {
  const url = `${ALTEGIO_API_URL}/client/${companyId}/${id}`;
  try {
    const response = await axios.get(url, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      },
      // params: {
      //   'company_id': companyId,
      //   id,
      // },
    });
    return response.data;
  } catch {
    throw new Error("Error getting client from Altegio");
  }
};

// Edit client
export const editClientFromAltegio = async (companyId: string, id: string, name: string, phone: string, surname: string, birthDate: string, sexId: number) => {
  const url = `${ALTEGIO_API_URL}/client/${companyId}/${id}`;
  try {
    const response = await axios.put(url, {
      name,
      phone,
      surname,
      'birth_date': birthDate,
      'sex_id': sexId,
    }, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      }
    });
    return response.data;
  } catch {
    throw new Error("Error editing client from Altegio");
  }
};

// Delete client
export const deleteClientFromAltegio = async (companyId: string, id: string) => {
  const url = `${ALTEGIO_API_URL}/client/${companyId}/${id}`;
  try {
    const response = await axios.delete(url, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      },
    });
    return response.data;
  } catch {
    throw new Error("Error deleting client from Altegio");
  }
};

// Freeze subscription
export const freezeSubscriptionFromAltegio = async (chainId: string, abonementId: string, freezeTill: string) => {
  const url = `${ALTEGIO_API_URL}/chain/${chainId}/loyalty/abonements/${abonementId}/freeze`;
  try {
    const response = await axios.post(url, {
      'freeze_till': freezeTill,
    }, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      }
    });
    return response.data;
  } catch {
    throw new Error("Error freezing subscription from Altegio");
  }
};

// Unfreeze subscription
export const unfreezeSubscriptionFromAltegio = async (chainId: string, abonementId: string) => {
  const url = `${ALTEGIO_API_URL}/chain/${chainId}/loyalty/abonements/${abonementId}/unfreeze`;
  try {
    const response = await axios.post(url, {}, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      }
    });
    return response.data;
  } catch {
    throw new Error("Error unfreezing subscription from Altegio");
  }
};

// Change subscription duration
export const changeSubscriptionDurationFromAltegio = async (chainId: string, abonementId: string, period: number, periodUnitId: number) => {
  const url = `${ALTEGIO_API_URL}/chain/${chainId}/loyalty/abonements/${abonementId}/set_period`;
  try {
    const response = await axios.post(url, {
      period,
      'period_unit_id': periodUnitId,
    }, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      }
    });
    return response.data;
  } catch {
    throw new Error("Error changing subscription period from Altegio");
  }
};

// Change the number of times a subscription has been used
export const changeNumberSubscriptionUsedTimesFromAltegio = async (chainId: string, abonementId: string, unitedBalanceServicesCount: number, servicesBalanceCount?: object) => {
  const url = `${ALTEGIO_API_URL}/chain/${chainId}/loyalty/abonements/${abonementId}/set_balance`;
  try {
    const response = await axios.post(url, {
      'united_balance_services_count': unitedBalanceServicesCount,
      'services_balance_count': servicesBalanceCount,
    }, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      }
    });
    return response.data;
  } catch {
    throw new Error("Error changing number of times a subscription has been used from Altegio");
  }
};

// Get customer subscriptions
export const getCustomerSubscriptionsFromAltegio = async (companyId: string, phone: string) => {
  const url = `${ALTEGIO_API_URL}/loyalty/abonements/`;
  try {
    const response = await axios.get(url, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      },
      params: {
        'company_id': companyId,
        phone,
      },
    });
    return response.data;
  } catch {
    throw new Error("Error getting customer subscriptions from Altegio");
  }
};

// Create a new entry
export const createNewEntry = async (companyId: string, services: Service[], client: Client, seanceLength: number, saveIfBusy?: boolean, datetime?: string, comment?: string, attendance?: number, apiId?: string, customFields?: object) => {
  const url = `${ALTEGIO_API_URL}/records/${companyId}`;
  try {
    debugger;

    const response = await axios.post(url, {
      "staff_id": 2759783,
      "services": [
        {
          "id": 12285138,
        }
      ],
      "client": {
        "phone": client.phone,
      },
      "save_if_busy": saveIfBusy,
      "datetime": datetime,
      "seance_length": seanceLength,
      "comment": comment,
      "api_id": apiId,
      "attendance": attendance,
      "custom_fields": customFields
    }, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      }
    });


    return response.data;
  } catch {
    throw new Error("Error creating a new entry in Altegio");
  }
};

// Get list of user records
export const getListOfUserRecords = async (companyId: string, clientId: string, startDate?: string, endDate?: string) => {
  const url = `${ALTEGIO_API_URL}/records/${companyId}`;
  try {
    const response = await axios.get(url, {
      headers: {
        "Authorization": `Bearer ${ALTEGIO_PARTNER_TOKEN}, User ${ALTEGIO_USER_TOKEN}`,
        "Content-Type": "application/json",
        "Accept": "application/vnd.api.v2+json",
      },
      params: {
        'client_id': clientId,
        'start_date': startDate,
        'end_date': endDate,
      },
    });
    return response.data;
  } catch {
    throw new Error("Error getting a list of user records from Altegio");
  }
};