import { apiRequest } from './client.js';

export function getCourses({ page = 0, size = 20, subject, status = 'ACTIVE' } = {}) {
  const params = new URLSearchParams({ page, size });
  if (subject) params.set('subject', subject);
  if (status) params.set('status', status);
  return apiRequest(`/courses?${params}`);
}

export function getCourseDetail(id) {
  return apiRequest(`/courses/${id}`);
}

function toCourseFormData(body) {
  const form = new FormData();
  form.append('title', body.title || '');
  form.append('description', body.description || '');
  form.append('subject', body.subject || '');
  if (body.thumbnailUrl) form.append('thumbnailUrl', body.thumbnailUrl);
  if (body.thumbnailFile) form.append('thumbnailFile', body.thumbnailFile);
  return form;
}

function toCourseJson(body) {
  return {
    title: body.title,
    description: body.description,
    subject: body.subject,
    thumbnailUrl: body.thumbnailUrl,
  };
}

export function createCourse(body) {
  return apiRequest('/courses/admin', {
    method: 'POST',
    body: body?.thumbnailFile ? toCourseFormData(body) : toCourseJson(body),
  });
}

export function updateCourse(id, body) {
  return apiRequest(`/courses/admin/${id}`, {
    method: 'PUT',
    body: body?.thumbnailFile ? toCourseFormData(body) : toCourseJson(body),
  });
}

export function deleteCourse(id) {
  return apiRequest(`/courses/admin/${id}`, { method: 'DELETE' });
}
