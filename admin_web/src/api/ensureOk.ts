import {
  customBaseQuery,
  messageFromErrorBody,
  type CustomBaseQueryArgs,
} from './customBaseQuery';

export class ApiError extends Error {
  constructor(
    message: string,
    public status: number,
    public body?: unknown
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

export async function apiJson<T>(args: CustomBaseQueryArgs): Promise<T> {
  const res = await customBaseQuery<T>(args);
  if ('error' in res) {
    throw new ApiError(
      messageFromErrorBody(res.error.data, `Lỗi ${res.error.status}`),
      res.error.status,
      res.error.data
    );
  }
  return res.data as T;
}

export async function apiFormPost<T>(path: string, formData: FormData): Promise<T> {
  const res = await customBaseQuery<T>({
    url: path,
    method: 'POST',
    body: formData,
  });
  if ('error' in res) {
    throw new ApiError(
      messageFromErrorBody(res.error.data, `Lỗi ${res.error.status}`),
      res.error.status,
      res.error.data
    );
  }
  return res.data as T;
}
