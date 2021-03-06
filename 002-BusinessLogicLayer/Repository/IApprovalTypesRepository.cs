﻿using System.Collections.Generic;

namespace ParkingSystem
{
	public interface IApprovalTypesRepository
	{
		List<ApprovalTypeModel> GetAllApprovalTypes();
		ApprovalTypeModel GetOneApprovalTypeByCode(string approvalCode);
		ApprovalTypeModel AddApprovalType(ApprovalTypeModel approvalTypeModel);
		ApprovalTypeModel UpdateApprovalType(ApprovalTypeModel approvalTypeModel);
		int DeleteApprovalType(string approvalCode);
	}
}
