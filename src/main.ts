import '@shared/loadEnv';
import http from 'http';
import { logger } from '@shared/logger';

const port = process.env.PORT ? parseInt(process.env.PORT, 10) : 9000;
const host = process.env.HOST || '0.0.0.0';

const server = http.createServer((req, res) => {
  res.writeHead(200);
  res.end('Hello');
});

server.listen(port, host, () => {
  logger.info(`Listening ${host}:${port}`);
});

function handleError(error: unknown) {
  // eslint-disable-next-line no-console
  console.error(error);
  // eslint-disable-next-line unicorn/no-process-exit
  process.exit(1);
}

process.on('uncaughtException', handleError);
