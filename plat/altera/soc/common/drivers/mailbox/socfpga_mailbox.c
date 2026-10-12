/*
 * Copyright (c) 2020-2023, Intel Corporation. All rights reserved.
 * Copyright (c) 2024-2025, Altera Corporation. All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 * This file is a thin wrapper layer.  Every public mailbox API function
 * dispatches to the active backend selected by mailbox_core_init():
 *
 *   Agilex27  -> MAILBOX_BACKEND_MCSR  (mcsr_backend)
 *   Agilex3   -> MAILBOX_BACKEND_SCSR  (scsr_backend)
 *
 * No direct hardware (MBOX_OFFSET) accesses are made here.
 */

#include <common/debug.h>
#include <platform_def.h>

#include "mailbox/socfpga_mailbox_core.h"
#include "socfpga_plat_def.h"
#include "socfpga_sip_svc.h"

/* -------------------------------------------------------------------------
 * Public wrappers -- all dispatch through the mailbox vtable pointer
 * set by mailbox_core_init(). Guard against NULL ops so backends may leave
 * unsupported slots unset (e.g. V3 when SOCFPGA_SIP_SVC_V3=0).
 * -------------------------------------------------------------------------
 */

int mailbox_read_response(uint32_t *job_id, uint32_t *response,
			  unsigned int *resp_len)
{
	if ((mailbox == NULL) || (mailbox->read_response == NULL)) {
		return MBOX_RET_ERROR;
	}

	return mailbox->read_response(job_id, response, resp_len);
}

int mailbox_read_response_async(uint32_t *job_id, uint32_t *header,
				uint32_t *response, unsigned int *resp_len,
				uint8_t ignore_client_id)
{
	if ((mailbox == NULL) || (mailbox->read_response_async == NULL)) {
		return MBOX_RET_ERROR;
	}

	return mailbox->read_response_async(job_id, header, response, resp_len,
						ignore_client_id);
}

int iterate_resp(uint32_t mbox_resp_len, uint32_t *resp_buf,
		 unsigned int *resp_len)
{
	if ((mailbox == NULL) || (mailbox->iterate_resp == NULL)) {
		return MBOX_RET_ERROR;
	}

	return mailbox->iterate_resp(mbox_resp_len, resp_buf, resp_len);
}

int mailbox_send_cmd_async_ext(uint32_t header_cmd, uint32_t *args,
			       unsigned int len)
{
	if ((mailbox == NULL) || (mailbox->send_async_ext == NULL)) {
		return MBOX_RET_ERROR;
	}

	return mailbox->send_async_ext(header_cmd, args, len);
}

int mailbox_send_cmd_async(uint32_t *job_id, uint32_t cmd, uint32_t *args,
			   unsigned int len, unsigned int indirect)
{
	if ((mailbox == NULL) || (mailbox->send_async == NULL)) {
		return MBOX_RET_ERROR;
	}

	return mailbox->send_async(job_id, cmd, args, len, indirect);
}

int mailbox_send_cmd(uint32_t job_id, uint32_t cmd, uint32_t *args,
		     unsigned int len, uint32_t urgent, uint32_t *response,
		     unsigned int *resp_len)
{
	if ((mailbox == NULL) || (mailbox->send == NULL)) {
		return MBOX_RET_ERROR;
	}

	return mailbox->send(job_id, cmd, args, len, urgent, response, resp_len);
}

void mailbox_clear_response(void)
{
	if ((mailbox == NULL) || (mailbox->clear_response == NULL)) {
		return;
	}

	mailbox->clear_response();
}

void mailbox_set_int(uint32_t interrupt)
{
	if ((mailbox == NULL) || (mailbox->set_int == NULL)) {
		return;
	}

	mailbox->set_int(interrupt);
}

int mailbox_send_cmd_async_v3(uint8_t client_id, uint8_t job_id, uint32_t cmd,
			      uint32_t *args, uint32_t args_len, uint8_t cmd_flag,
			      sdm_command_callback cb, uint32_t *cb_args,
			      uint32_t cb_args_len)
{
	if ((mailbox == NULL) || (mailbox->send_async_v3 == NULL)) {
		return MBOX_RET_ERROR;
	}

	return mailbox->send_async_v3(client_id, job_id, cmd, args, args_len,
				  cmd_flag, cb, cb_args, cb_args_len);
}

int mailbox_response_poll_on_intr_v3(uint8_t *client_id, uint8_t *job_id,
				     uint64_t *bitmap)
{
	if ((mailbox == NULL) || (mailbox->response_poll_on_intr_v3 == NULL)) {
		return MBOX_RET_ERROR;
	}

	return mailbox->response_poll_on_intr_v3(client_id, job_id, bitmap);
}

int mailbox_response_poll_v3(uint8_t client_id, uint8_t job_id,
			     uint64_t *ret_args, uint32_t *ret_args_len)
{
	if ((mailbox == NULL) || (mailbox->response_poll_v3 == NULL)) {
		return MBOX_RET_ERROR;
	}

	return mailbox->response_poll_v3(client_id, job_id, ret_args, ret_args_len);
}
