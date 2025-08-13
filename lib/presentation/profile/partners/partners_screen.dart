import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/presentation/profile/partners/bloc/partners_bloc.dart';
import 'package:flutter_founders/presentation/profile/partners/bloc/partners_event.dart';
import 'package:flutter_founders/presentation/profile/partners/bloc/partners_state.dart';
import 'package:flutter_founders/presentation/profile/models/partner_model.dart';
import 'package:flutter_founders/presentation/profile/models/partner_request_model.dart';
import 'package:flutter_founders/presentation/profile/other_profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<PartnersBloc>();
    bloc.add(LoadPartners());
    bloc.add(LoadIncomingRequests());
    bloc.add(LoadOutgoingRequests());
  }

  void _reloadAll() {
    final bloc = context.read<PartnersBloc>();
    bloc.add(LoadPartners());
    bloc.add(LoadIncomingRequests());
    bloc.add(LoadOutgoingRequests());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Партнёры',
            style: GoogleFonts.inriaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Обновить',
              onPressed: _reloadAll,
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Партнёры'),
              Tab(text: 'Входящие'),
              Tab(text: 'Исходящие'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_PartnersTab(), _IncomingTab(), _OutgoingTab()],
        ),
      ),
    );
  }
}

/// --------------------
/// Tab 1: Current Partners
/// --------------------
class _PartnersTab extends StatelessWidget {
  const _PartnersTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnersBloc, PartnersState>(
      buildWhen: (p, c) =>
          p.partners != c.partners ||
          p.isLoadingPartners != c.isLoadingPartners ||
          p.errorPartners != c.errorPartners,
      builder: (context, state) {
        if (state.isLoadingPartners) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (state.errorPartners != null) {
          return Center(
            child: Text(
              state.errorPartners!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state.partners.isEmpty) {
          return const _EmptyMessage(text: 'Нет партнёров');
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemBuilder: (_, i) => _PartnerTile(partner: state.partners[i]),
          separatorBuilder: (_, __) =>
              const Divider(color: Colors.white12, height: 1),
          itemCount: state.partners.length,
        );
      },
    );
  }
}

class _PartnerTile extends StatelessWidget {
  final PartnerModel partner;
  const _PartnerTile({required this.partner});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundImage:
            (partner.userAvatar != null && partner.userAvatar!.isNotEmpty)
                ? NetworkImage(partner.userAvatar!)
                : null,
        child: (partner.userAvatar == null || partner.userAvatar!.isEmpty)
            ? Text(
                partner.userName.isNotEmpty ? partner.userName[0] : '?',
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
      title: Text(
        partner.userName,
        style: GoogleFonts.inriaSans(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((partner.companyName ?? '').isNotEmpty)
            Text(
              partner.companyName!,
              style: GoogleFonts.inriaSans(
                color: const Color(0xFFAF925D),
                fontSize: 13,
              ),
            ),
          if ((partner.companyIndustry ?? '').isNotEmpty)
            Text(
              partner.companyIndustry!,
              style: GoogleFonts.inriaSans(color: Colors.white70, fontSize: 12),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtherProfileScreen(userId: partner.id),
          ),
        );
      },
    );
  }
}

/// --------------------
/// Tab 2: Incoming Requests
/// --------------------
class _IncomingTab extends StatelessWidget {
  const _IncomingTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnersBloc, PartnersState>(
      buildWhen: (p, c) =>
          p.incoming != c.incoming ||
          p.isLoadingIncoming != c.isLoadingIncoming ||
          p.errorIncoming != c.errorIncoming,
      builder: (context, state) {
        if (state.isLoadingIncoming) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (state.errorIncoming != null) {
          return Center(
            child: Text(
              state.errorIncoming!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state.incoming.isEmpty) {
          return const _EmptyMessage(text: 'Нет входящих запросов');
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: state.incoming.length,
          separatorBuilder: (_, __) =>
              const Divider(color: Colors.white12, height: 1),
          itemBuilder: (_, i) {
            final req = state.incoming[i];
            return _IncomingTile(req: req);
          },
        );
      },
    );
  }
}

class _IncomingTile extends StatelessWidget {
  final PartnerRequestModel req;
  const _IncomingTile({required this.req});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(req.requesterId.toString())),
      title: Text(
        'Запрос от пользователя ${req.requesterId}',
        style: GoogleFonts.inriaSans(color: Colors.white),
      ),
      subtitle: Text(
        'Статус: ${req.status}',
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              context.read<PartnersBloc>().add(
                    RespondIncomingRequest(id: req.id, status: 'accepted'),
                  );
            },
            child: const Text('Принять'),
          ),
          TextButton(
            onPressed: () {
              context.read<PartnersBloc>().add(
                    RespondIncomingRequest(id: req.id, status: 'rejected'),
                  );
            },
            child: const Text('Отклонить'),
          ),
        ],
      ),
    );
  }
}

/// --------------------
/// Tab 3: Outgoing Requests
/// --------------------
class _OutgoingTab extends StatelessWidget {
  const _OutgoingTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnersBloc, PartnersState>(
      buildWhen: (p, c) =>
          p.outgoing != c.outgoing ||
          p.isLoadingOutgoing != c.isLoadingOutgoing ||
          p.errorOutgoing != c.errorOutgoing,
      builder: (context, state) {
        if (state.isLoadingOutgoing) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (state.errorOutgoing != null) {
          return Center(
            child: Text(
              state.errorOutgoing!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state.outgoing.isEmpty) {
          return const _EmptyMessage(text: 'Нет исходящих запросов');
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: state.outgoing.length,
          separatorBuilder: (_, __) =>
              const Divider(color: Colors.white12, height: 1),
          itemBuilder: (_, i) {
            final req = state.outgoing[i];
            return ListTile(
              leading: CircleAvatar(child: Text(req.recipientId.toString())),
              title: Text(
                'Запрос к пользователю ${req.recipientId}',
                style: GoogleFonts.inriaSans(color: Colors.white),
              ),
              subtitle: Text(
                'Статус: ${req.status}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: TextButton(
                onPressed: () {
                  // ✅ إلغاء الطلب الصادر باستخدام requestId الحقيقي
                  context.read<PartnersBloc>().add(
                        CancelOutgoingRequest(req.id),
                      );
                },
                child: const Text('Отменить'),
              ),
            );
          },
        );
      },
    );
  }
}

/// --------------------
/// Empty message widget
/// --------------------
class _EmptyMessage extends StatelessWidget {
  final String text;
  const _EmptyMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: GoogleFonts.inriaSans(color: Colors.white54)),
    );
  }
}
